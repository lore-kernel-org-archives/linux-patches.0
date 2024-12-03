Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D091F892F;
	Tue,  3 Dec 2024 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242675; cv=none; b=kAzRkLlDK5hQsgHzMUpprcNXaRzjN3Sun0xSAv0Deq2bOU6CZMU+AJPX7Q/NfuGn+JGF5XmzbQ7NotzeGW6pOxpSqNjhb9FlgSubLVp6WeQUv8EfZSFg5JlB6TCHQ/9RhVq/SmRkXyt08h+F0tudL9UaV37WEILeGjPD3PG2wYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242675; c=relaxed/simple;
	bh=p+qpcbUKEpWeSO7Ws2fgdMdEIoF6CSAd+pnUBK+NPDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP6KRkdEDtcbPTMq97Qj5ROs6+zpM42MAOKssvkL6q10U0CcMVOG2QXUYt6oue1fbobyv1fEw65btHMUCxTJZsaIWRz8a+JEPWMe8JjdC5SmrAcveE0yT+j6+ZsI+DBx/eSwwlFzX3XXYSIQVbXVhIRyL6NAwAr+XaiqG6wJtcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6aQp/RF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6aQp/RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAF6C4CECF;
	Tue,  3 Dec 2024 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242675;
	bh=p+qpcbUKEpWeSO7Ws2fgdMdEIoF6CSAd+pnUBK+NPDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6aQp/RF3eX2uOcsVjcsu1npQ2Pb0hFqz+snTApZsb/+MSus89htWQtM2+evc9w5M
	 M0efpbtFhDiWndtVTvX9jubt1fobXtTrmLUq/E1KhBShYe4DEQk5lwZ06zLChx1psJ
	 gLAdZdNviw3w/ncBdwOcyCXdywZYDcQRMKeHwJgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 775/826] um: ubd: Initialize ubds disk pointer in ubd_add
Date: Tue,  3 Dec 2024 15:48:22 +0100
Message-ID: <20241203144813.999139955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit df700802abcac3c7c4a4ced099aa42b9a144eea8 ]

Currently, the initialization of the disk pointer in the ubd structure
is missing. It should be initialized with the allocated gendisk pointer
in ubd_add().

Fixes: 32621ad7a7ea ("ubd: remove the ubd_gendisk array")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Link: https://patch.msgid.link/20241104163203.435515-2-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 119df76627002..2bfb17373244b 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -898,6 +898,8 @@ static int ubd_add(int n, char **error_out)
 	if (err)
 		goto out_cleanup_disk;
 
+	ubd_dev->disk = disk;
+
 	return 0;
 
 out_cleanup_disk:
-- 
2.43.0



