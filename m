Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C4F22F06;
	Thu, 18 Jan 2024 10:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575015; cv=none; b=h+yRlwjtieUkuJdxG2Qn2zDCMG0Z7D64uIwtfpld+bWmBz2HN2KQGxlI19qaJl9sccpG5iQt2DZUMtZxEuEkrXrz+Ll7KbGamUkTMl+0LWKeMQh5HAHBXjxU761t1y8DqbMTbnrYd6uRHd0ZOuDeI7fap3km4qz244rDVxqZLk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575015; c=relaxed/simple;
	bh=mXvSTL/F1V1VeiHkFOuIc4QNCY3XXbyrDTQywFmz8rE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=Cop+3lLX93wZ44rcLkq58bG8o+lh3dDaJDh03cEQYKL9pNcA2pGvsR3MV2iWVm6uM1YwBaPWcT1HpyAHWIGufVD7vvp/xPWo06IlhcYmHWwF6mR88U1KSZmwyDI2ZYvHM1/5LK1WkOy3rDKEoI6upt4nR7RZ8n989lgjOw8mu6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1hL1o8E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1hL1o8E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBE0C433C7;
	Thu, 18 Jan 2024 10:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575015;
	bh=mXvSTL/F1V1VeiHkFOuIc4QNCY3XXbyrDTQywFmz8rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U1hL1o8EGmVoGW/zqTS4EUhG6XhF+lyygUWU/cik1ISjCutYfBOQA1OisZ3Nu4gmF
	 6dRu2os1NfcgfHBFpictow53NZKuqF4Z7igQq4k0PSQBPwV9uTDf59ccMS8MRCoWOj
	 OnLq+QTq0PlUGVHmlIOcYWuCvsjSLroGYlrwisvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sjoerd Simons <sjoerd@collabora.com>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: [PATCH 6.7 10/28] bus: moxtet: Mark the irq as shared
Date: Thu, 18 Jan 2024 11:49:00 +0100
Message-ID: <20240118104301.589412437@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjoerd Simons <sjoerd@collabora.com>

commit e7830f5a83e96d8cb8efc0412902a03008f8fbe3 upstream.

The Turris Mox shares the moxtet IRQ with various devices on the board,
so mark the IRQ as shared in the driver as well.

Without this loading the module will fail with:
  genirq: Flags mismatch irq 40. 00002002 (moxtet) vs. 00002080 (mcp7940x)

Signed-off-by: Sjoerd Simons <sjoerd@collabora.com>
Cc:  <stable@vger.kernel.org> # v6.2+
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/moxtet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/moxtet.c
+++ b/drivers/bus/moxtet.c
@@ -755,7 +755,7 @@ static int moxtet_irq_setup(struct moxte
 	moxtet->irq.masked = ~0;
 
 	ret = request_threaded_irq(moxtet->dev_irq, NULL, moxtet_irq_thread_fn,
-				   IRQF_ONESHOT, "moxtet", moxtet);
+				   IRQF_SHARED | IRQF_ONESHOT, "moxtet", moxtet);
 	if (ret < 0)
 		goto err_free;
 


