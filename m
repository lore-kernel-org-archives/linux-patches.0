Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0490138396;
	Tue,  1 Oct 2024 08:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727771097; cv=none; b=IcxIPzyt9GG74rJsw5AGYL5DY5AFWs0xLhGZUrXHZBuLyyOGhE8U1Dyq2byreby4buZ7NRbG4gytdZaVWkTcpAZMska5JZZI1ra3BD+jdDD18u/oq9ix9ZjBzR9riU3NYGztPen9ou310IUn5IjDDMHVjUW7FnAqraqpnGE4MTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727771097; c=relaxed/simple;
	bh=jjKt8LVt24y6tOoj2LzH+0HxT7QfFbaYDPX8SaFuQvY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=owARg1/xweSqPAPUYhEyqr5q6aZ6jGj93g1+3Osysc1TvB5FVD+B0fT3gJT0esfNWB8p3Fb4VUP/yuJuGTIvl/sxVPeRL8yoWWf7OThp3Ai6JjGjWandJhkFj9K8vgVJHB9ENQZj7ZXYoQh4dB1y1g0PE993qF9Dt5kZ3hEpVC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pYI7hjN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pYI7hjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842DAC4CEC6;
	Tue,  1 Oct 2024 08:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727771096;
	bh=jjKt8LVt24y6tOoj2LzH+0HxT7QfFbaYDPX8SaFuQvY=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=0pYI7hjNY/bdZ/VTVu8ycMYdFSZ4Uk6xnZqlritFZGftU6OPcOrWjYbQ38AWvC/ZS
	 fQY672iYjSLn+ldJFQY+FbdSpQNBbTLGsbYA2O5tdaE6FcWpOMJOGglobFHBhsHCpV
	 +Glg4FxoHVIUUouUYl2Z3vzyLJ/QeCTdR/OWcFxA=
Subject: Patch "[PATCH net] Revert "net: libwx: fix alloc msix vectors failed"" has been added to the 6.6-stable tree
To: davem@davemloft.net,duanqiangwen@net-swift.com,gregkh@linuxfoundation.org,patches@lists.linux.dev
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 01 Oct 2024 10:20:55 +0200
In-Reply-To: <20240930073327.130343-1-duanqiangwen@net-swift.com>
Message-ID: <2024100155-igloo-willing-518f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    [PATCH net] Revert "net: libwx: fix alloc msix vectors failed"

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     revert-net-libwx-fix-alloc-msix-vectors-failed.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From duanqiangwen@net-swift.com  Tue Oct  1 10:14:13 2024
From: Duanqiang Wen <duanqiangwen@net-swift.com>
Date: Mon, 30 Sep 2024 15:33:27 +0800
Subject: [PATCH net] Revert "net: libwx: fix alloc msix vectors failed"
To: stable@vger.kernel.org, patches@lists.linux.dev, gregkh@linuxfoundation.org, davem@davemloft.net, ashal@kernel.org
Cc: Duanqiang Wen <duanqiangwen@net-swift.com>
Message-ID: <20240930073327.130343-1-duanqiangwen@net-swift.com>

From: Duanqiang Wen <duanqiangwen@net-swift.com>

This reverts commit 69197dfc64007b5292cc960581548f41ccd44828.
commit 937d46ecc5f9 ("net: wangxun: add ethtool_ops for
channel number") changed NIC misc irq from most significant
bit to least significant bit, the former condition is not
required to apply this patch, because we only need to set
irq affinity for NIC queue irq vectors.
this patch is required after commit 937d46ecc5f9 ("net: wangxun:
add ethtool_ops for channel number") was applied, so this is only
relevant to 6.6.y branch.

Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1585,7 +1585,7 @@ static void wx_set_num_queues(struct wx
  */
 static int wx_acquire_msix_vectors(struct wx *wx)
 {
-	struct irq_affinity affd = { .pre_vectors = 1 };
+	struct irq_affinity affd = {0, };
 	int nvecs, i;
 
 	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);


Patches currently in stable-queue which might be from duanqiangwen@net-swift.com are

queue-6.6/revert-net-libwx-fix-alloc-msix-vectors-failed.patch
