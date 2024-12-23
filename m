Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66677E0FF;
	Mon, 23 Dec 2024 16:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970385; cv=none; b=APeJ1+7Oq2Q0Izf9TlvONtoCZ2XegCC3wqC3j9l1msbvJep7L6t0rvRROnXZlM/XjdSiZUiS05UEg7YhM0gtsdF1W3gRdtyDQeEh1P0lB6gUhe8/fvyiLyKyKaUjWybY4YUggjPABdggnfBol0kwxuV10/aVqluQVGpZilDM3rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970385; c=relaxed/simple;
	bh=DgD3Sojd5H7hq9jWxP9R4WdwQZehzngsfUCRGyHMf2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTRxeSPwU8JQTHq1ixQp0bw4LmcTmLE0p0SD/+uPRKiGzuEXG52BSpVxfPCC9N58cr/kSll5A+JZ1bKX9ajoHoBu6fzV48WRIUIAg50kpg3tMFPc7XJ6XX25/Y4SDf7g4534GQ0p5ZnuUvLRCD4NOnuPV7tD89y1lwmxhiHZhtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKlsLpZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKlsLpZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC6CC4CED3;
	Mon, 23 Dec 2024 16:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970385;
	bh=DgD3Sojd5H7hq9jWxP9R4WdwQZehzngsfUCRGyHMf2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKlsLpZVxgEUuzB9I02muzJKAvvh160aUBI5ovOIgOYGfn1KsX0c1n0iAS1P+QtRZ
	 72cBQL5GwAZZ0BWPN8xFtU4wUPobMM3454oRG28VjwuV8rZzeSUidhmK/k4zuUGVu2
	 LSHO9LHatGa9WerYg3mZh50ed0WKJPWKUy/EmR7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/116] tools: hv: change permissions of NetworkManager configuration file
Date: Mon, 23 Dec 2024 16:58:26 +0100
Message-ID: <20241223155400.976151573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 91ae69c7ed9e262f24240c425ad1eef2cf6639b7 ]

Align permissions of the resulting .nmconnection file, instead of
the input file from hv_kvp_daemon. To avoid the tiny time frame
where the output file is world-readable, use umask instead of chmod.

Fixes: 42999c904612 ("hv/hv_kvp_daemon:Support for keyfile based connection profile")
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Link: https://lore.kernel.org/r/20241016143521.3735-1-olaf@aepfle.de
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20241016143521.3735-1-olaf@aepfle.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_set_ifconfig.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
index 440a91b35823..2f8baed2b8f7 100755
--- a/tools/hv/hv_set_ifconfig.sh
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -81,7 +81,7 @@ echo "ONBOOT=yes" >> $1
 
 cp $1 /etc/sysconfig/network-scripts/
 
-chmod 600 $2
+umask 0177
 interface=$(echo $2 | awk -F - '{ print $2 }')
 filename="${2##*/}"
 
-- 
2.39.5



