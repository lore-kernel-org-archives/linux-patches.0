Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6879114B976;
	Fri,  6 Dec 2024 14:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496024; cv=none; b=iH7aLshVqJg+vpv2nWZJaUEGsllFe8qBASDrwlha4VZCcEm5CW/RI9MXhb/Su/q5A65NQnIBX/zcPDO+pA4oNEZ4e934XK2hQ3iaCcZ6phkpXQ1jjrtJwUcJcHMU7X+EYB/giX8OFFSbCkT4xwJHymLOPwUUF0yhtcJH+zzIjac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496024; c=relaxed/simple;
	bh=8WZrRsEXgfrGRtIaSy/of9Za2uExTaxLpSI82jRknQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqXG8jtBmBCBggKtizG/2z3YPNx4CbX0sPtop/YtJCNuiE+O6oCtVntDaWe73/DBaC73q1bZ7ihKTFiCqU0UEwVTgWt8GzSoqlO8lnScsls7bbv1J0TZH+H4iXt1gUoTzr4A2h2EfqdckJXim8pNHOpHFxMFHgNfCaeguGfKiNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PhCftqOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PhCftqOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D4C4CEDC;
	Fri,  6 Dec 2024 14:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496024;
	bh=8WZrRsEXgfrGRtIaSy/of9Za2uExTaxLpSI82jRknQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhCftqOcMi1xwcjuKcOv1tuiVKkRkelny6FybUUfnIqON6xYyMqDe4Hyiv8egDMvI
	 DquizJaqmv+FcUtW08rRHSuHynSCCoDzPOvwpX0s78m95kyWs/6HA+nQwkTX1sh0oG
	 Uqd+2i8BRxfqxjRTz0rdlPb0AFk33952NVBsxJLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.12 013/146] md/md-bitmap: Add missing destroy_work_on_stack()
Date: Fri,  6 Dec 2024 15:35:44 +0100
Message-ID: <20241206143528.179932837@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

commit 6012169e8aae9c0eda38bbedcd7a1540a81220ae upstream.

This commit add missed destroy_work_on_stack() operations for
unplug_work.work in bitmap_unplug_async().

Fixes: a022325ab970 ("md/md-bitmap: add a new helper to unplug bitmap asynchrously")
Cc: stable@vger.kernel.org
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20241105130105.127336-1-yuancan@huawei.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1285,6 +1285,7 @@ static void bitmap_unplug_async(struct b
 
 	queue_work(md_bitmap_wq, &unplug_work.work);
 	wait_for_completion(&done);
+	destroy_work_on_stack(&unplug_work.work);
 }
 
 static void bitmap_unplug(struct mddev *mddev, bool sync)


