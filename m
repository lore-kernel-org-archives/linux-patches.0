Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C853B6
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23339C341C7
	for <patches@lists.linux.dev>; Wed, 20 Jul 2022 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1658326656;
	bh=fBUIQAnUzMAi0Mj8MutPlWW1hVKj/9qq3xfmLfSk7w8=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=kcjAdpoPqrkf0/AloBjMdUJwHruNozRNgA/N/wSLu6bySqL4SLNFcCQb7MNB+hevk
	 f34f1cyoaxcqLHaIfJ6RSZMPbkmuj5/foRLx6YtFOvHJdMqIRGaJDWfc8Yy5qiUcAZ
	 MUktSjTLNPA0Z95nH6unm86O8qnII8Uj+x2oedYE=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Wed, 20 Jul 2022 10:17:36 -0400
Subject: [PATCH v2 3/3] README: rename Linux to Kahlux
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220720-claim-for-kahless-v2-3-ddbde3dd27ea@linuxfoundation.org>
References: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
In-Reply-To: <20220720-claim-for-kahless-v2-0-ddbde3dd27ea@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-45aaa
X-Developer-Signature: v=1; a=openpgp-sha256; l=458;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=fBUIQAnUzMAi0Mj8MutPlWW1hVKj/9qq3xfmLfSk7w8=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJJu8NXrnV/x+JCrqXRU5r5Ln7yEdmpk9901CXGdKz9vwuMD
 r1mMOkpZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEzk3nKG/+U7b/R9aKwxDFV6ZnZP1l
 XWZcKMgxtZA+OXXd6xpqE2K5rhr8Q+dc0FE8+7mU3p3iV2+wKDc1t5Mted/S+zPzZv0WOfzg8A
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

The name speaks for itself!

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/README b/README
index 669ac7c32292..3a48a87cbc83 100644
--- a/README
+++ b/README
@@ -1,5 +1,5 @@
-Linux kernel
-============
+Kahlux kernel
+=============
 
 There are several guides for kernel developers and users. These guides can
 be rendered in a number of formats, like HTML and PDF. Please read

-- 
b4 0.10.0-dev-45aaa
