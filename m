Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8810F2F2347;
	Tue, 15 Jul 2025 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587881; cv=none; b=DetxCF4KrYFYDIYkd9jUZURkfnu8QeVoDKrQsoApbKsnsXZlU4FWB/GIen9ruVFpYwQiiYVv83jbAJlyxgOFXlpp3va22Ca5LjVsmS9wFPV6zLYBtHvFrMiww2aTpkF1Hl2oDgFvcQZNqRzKYcHf+MKSV0QpwIq2Mg3qSOBmWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587881; c=relaxed/simple;
	bh=1SqV7zBbk5qdXd1NApZMogttOjbyEmeJyGMr5tK7whA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaHDNJ3VJiGapJ5LQ/6y0LVy4rVsU1mtI1oEI9vX8wuzn3O4dvDe5sISSCA/plnJYd10F3GHeABagj4V693HuKWHDBsPVIc645DT2z399n/iFtuhSQAEn+07aAV1gy9lQmvk78dpL9jw2l5wFxwiATdXsTNWLT0NKzF0zArba3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dfxB3/T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dfxB3/T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCBDC4CEE3;
	Tue, 15 Jul 2025 13:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587881;
	bh=1SqV7zBbk5qdXd1NApZMogttOjbyEmeJyGMr5tK7whA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfxB3/T3YD7UbKLayOtReCpcTX+HxQpINN0lu2WOq8DMpU2ll1x1SBCZxa5a/wHFc
	 K/D0rAIOniAGiMOXAwE4S5Of99h/eWGSX48HXM6TNz1PicEcn1BjouptqED2g5Uaeo
	 xsX8L8jb4YJSqo9SEiBGA3ghZOZ92FV5GHAFiLXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 179/208] rtc: lib_test: add MODULE_LICENSE
Date: Tue, 15 Jul 2025 15:14:48 +0200
Message-ID: <20250715130818.134468537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

commit 5546e3dfb65a4389e747766ac455a50c3675fb0f upstream.

As the documentation states, "The exact license information can only be
determined via the license information in the corresponding source files."
and the SPDX identifier has the proper information.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210810212008.631359-1-alexandre.belloni@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/lib_test.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/rtc/lib_test.c
+++ b/drivers/rtc/lib_test.c
@@ -77,3 +77,5 @@ static struct kunit_suite rtc_lib_test_s
 };
 
 kunit_test_suite(rtc_lib_test_suite);
+
+MODULE_LICENSE("GPL");


