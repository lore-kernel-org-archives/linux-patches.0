Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1824F2DF3EA;
	Tue, 21 Jul 2026 18:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660026; cv=none; b=h5VNciFh8KojbeeF3sjXbFxPuEnE9fa5kIvn+aWoRTZU/T0369cDmkjuoteBOsoq38hzj0vlkwcWQAj4VLWSsmmuvxSU41iTVXOkMDOodsWKK1LMPatUWpdPtP9j98ArVMxe9jOcT3nCUMLPhJZt9i902+1EeHRL+I8Un86P5zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660026; c=relaxed/simple;
	bh=TBhVxO3yBcW8KIKk0uvOM8aP8oNV10IPQgnS9MfofG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m98FrUE5aLdt3pi+u8Mkw90/elfG4ftDS8aEIfG8KyjnnWkHuBZ4bMOeUboeUvcYANtf0gAIugv326HykWvs5FG+3yJvEehUgd+8pX9iv7OR/HkJBftqrzj8uZnMqV4kJSXj7aHyn27uHgY/PgX5G7bOT+LGk0A0iWFq4iM5p+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5WU2UmP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5WU2UmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0DC1F00A3A;
	Tue, 21 Jul 2026 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660024;
	bh=qUJ69vABPHFYPWrmwtdQFWM3wDTzfjKeH6K5qb31aM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5WU2UmP8DqGdv4ns2okAJ/p1Wt9y7EerJAPgNkwPh0b1gn83/aQxPKNvCe1pLWrQ
	 olxuIGidBiZxewTObP7yWYGgnzDDYAp+OnblJv37A9Vpg1/+TcPZ1Mw+eQQgxsxHgY
	 kX92EZKzL4fjEYfiHdKrZwCEGQjD82oEDP1BVwKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0821/2077] mfd: bd72720: Drop BUCK11 ID
Date: Tue, 21 Jul 2026 17:08:14 +0200
Message-ID: <20260721152612.153932397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 6a2cb13761d90ef3fa960db189a2cc1bdf965ae1 ]

The BD72720 header reserves an ID for BUCK11. While this does not (at
the moment) cause problems I can see, it is misleading as the BD72720
contains only 10 BUCKs.

Make the code clearer and drop the BUCK11 ID.

Fixes: af25277b1ddc ("mfd: rohm-bd71828: Support ROHM BD72720")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/812c3749a18d609d6f4698506bc516ec7183dfdd.1775565298.git.mazziesaccount@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/rohm-bd72720.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mfd/rohm-bd72720.h b/include/linux/mfd/rohm-bd72720.h
index ae7343bcab064c..d8ddbf232bb3ee 100644
--- a/include/linux/mfd/rohm-bd72720.h
+++ b/include/linux/mfd/rohm-bd72720.h
@@ -21,7 +21,6 @@ enum {
 	BD72720_BUCK8,
 	BD72720_BUCK9,
 	BD72720_BUCK10,
-	BD72720_BUCK11,
 	BD72720_LDO1,
 	BD72720_LDO2,
 	BD72720_LDO3,
-- 
2.53.0



