Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D44C69
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C78BC341C8
	for <patches@lists.linux.dev>; Fri, 15 Jul 2022 19:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657912829;
	bh=P+FnLltk9UYBVrpbEHsSXiv+du+5tvTKch2FvZaBhH4=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=xOhbtJLerbrqjegd7Im+mtZzoyEnqYjIdp/XV0N2wborjGWtHZg8vseSb//dW1j4O
	 LWwzCLk2qGf+l6ttAgqMVas7THOZObLeGlAaV11zXooUTPm3GMGJKMgdJxTMb0PB/l
	 ibhryhigMv1Cp70lzADuoa2YpK0/vX0m87lMiBhM=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 15 Jul 2022 15:20:29 -0400
Subject: [PATCH v2 1/3] Rename Linux into Konix
Message-Id: <20220707-my-new-branch-v2-1-c378d618b16b@linuxfoundation.org>
References: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
In-Reply-To: <20220707-my-new-branch-v2-0-c378d618b16b@linuxfoundation.org>
To: Linux Patches <patches@lists.linux.dev>
X-Mailer: b4 0.10.0-dev-05523
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Developer-Signature: v=1; a=openpgp-sha256; l=637;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=P+FnLltk9UYBVrpbEHsSXiv+du+5tvTKch2FvZaBhH4=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIu7v17d/5JtjMrmUKVUvaIvpm4+0L2UbddKsfTmhrWXr6w
 68PZCR2lLAxiXAyyYoosZftiNwUVPvSQS+8xhZnDygQyhIGLUwAmElnB8N9pxYXw/e83TTyuxHi7Po
 Er5KC/CSPn3jvd/et9l3Ld7/dk+KeVKdUovq1iwcf0s9N0n3m/2FK883/khq1XP168b7q95Q0bAA==
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is not a real commit. I am using this series to test b4-submit
functionality.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Suggested-by: Rando Stranger <icon@mricon.com>
Acked-by: Lol Whoelse <mricon@kernel.org>
Reviewed-by: Singlepatch Mismatchy <konstantin@linuxfoundation.org>
Tested-by: Mister Mismatchy <mricon@kernel.org>

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
