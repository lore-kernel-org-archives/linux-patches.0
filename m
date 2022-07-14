Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F08601A
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED446C34115
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657828354;
	bh=aADSry3s1To4AL+gY3ck2LFkVtguXWvVkqNb++WcXy0=;
	h=From:Date:Subject:References:To:From;
	b=wHbjUCBUhjB2AydDU0HedZwsGW7t7uEQkk5tse+QyTmWE7mu2+TtZxvS90S81s+IP
	 LRkO7xWJLbj8pDXquKKH06QdDDpVWypyrln3YxVsZvmTgYGuQEYSlMZo4T0jZErx5X
	 olT4M6kPBxc0e19l6SaEFqnrVfAxhKzdbTbk8H9w=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 14 Jul 2022 15:52:33 -0400
Subject: [PATCH WIP v1 1/3] Rename Linux into Konix
Message-Id: <20220707-my-new-branch-v1-1-8d355bae1bb5@linuxfoundation.org>
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=476;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=aADSry3s1To4AL+gY3ck2LFkVtguXWvVkqNb++WcXy0=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIulDCujZEzfnJI/sIRLdtZKuIGe97/tt1Zdtdl7qPrDE5P
 Lr9u7ShlYRDjYpAVU2Qp2xe7KajwoYdceo8pzBxWJpAhDFycAjCRsmcMf8U+/J+3wmqzoH3lBMVkUZ
 XbReY/b2xwUOhzNloXlpD3yYGR4drJpf4yn5Zuj7f8xXZxhlZii33awcoZFyw4b6xcLS8awgcA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using this series to test b4-submit
functionality.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Suggested-by: Rando Stranger <icon@mricon.com>

diff --git a/README b/README
index 669ac7c32292..4c96d360c945 100644
--- a/README
+++ b/README
@@ -1,4 +1,4 @@
-Linux kernel
+Konix kernel
 ============
 
 There are several guides for kernel developers and users. These guides can

-- 
b4 0.10.0-dev-05523
