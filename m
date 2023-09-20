Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8698730FA7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B9BC433C7;
	Wed, 20 Sep 2023 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212772;
	bh=BbLVtigG1+zqD6T0J4lm7wXk8IKhNHEmNULyNI0yNGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHil8gNW5HEhhcTPuzQ+zpSVAVyRSfrix9ZNcShei57W/8VQ+wMj89vAc5RoP4Uh1
	 fd6ScG9OBCGvJ8f/5gPMF2Q5+rQZYeSR4Ixf6p2FoVR0jf2ihnJVId2bXT5i+suiWr
	 yFVHrmzPtJ1iwDzZRK55AdtSyU2DBNPDtnBjK94U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.4 013/367] firmware: stratix10-svc: Fix an NULL vs IS_ERR() bug in probe
Date: Wed, 20 Sep 2023 13:26:30 +0200
Message-ID: <20230920112858.850334306@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Ming <machel@vivo.com>

commit dd218433f2b635d97e8fda3eed047151fd528ce4 upstream.

The devm_memremap() function returns error pointers.
It never returns NULL. Fix the check.

Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Ming <machel@vivo.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20230727193750.983795-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -616,7 +616,7 @@ svc_create_memory_pool(struct platform_d
 	paddr = begin;
 	size = end - begin;
 	va = devm_memremap(dev, paddr, size, MEMREMAP_WC);
-	if (!va) {
+	if (IS_ERR(va)) {
 		dev_err(dev, "fail to remap shared memory\n");
 		return ERR_PTR(-EINVAL);
 	}


