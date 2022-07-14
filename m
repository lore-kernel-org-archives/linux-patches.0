Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DB0600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB94C34114
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1657828353;
	bh=iDeSXDOhn3tiByfrRjUEh7H/xCv63ArwcZFKQ8np4Mo=;
	h=Subject:From:Date:To:From;
	b=08fPueHkXd4jrPsLYoULhjDBeOTCUI7DQAlTMwCCM2r1XD5IND0P/pkYtXhy37BQy
	 NBz9In9QtstgQXZuc+2O8a9LZKs0mx3GqAI/VUsX1FbLJV3F5YGzFW3LOuTUupFazB
	 MEE8MacBQY86O+/BJF8EzdwQVB9k++70EkT7ZI00=
Subject: [PATCH WIP v1 0/3] Fake series to test out b4 submit
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 14 Jul 2022 15:52:32 -0400
Message-Id: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=733;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=iDeSXDOhn3tiByfrRjUEh7H/xCv63ArwcZFKQ8np4Mo=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJIulDAKxVU3mMmeuTvFOoGPZYEsz3aGSO6OxX1+XPdYvLxt
 V57pKGVhEONikBVTZCnbF7spqPChh1x6jynMHFYmkCEMXJwCMJF0HYZ/2k1hqtfqIut+23f1FLxqYG
 KfbCDDoRojw8n+qiVl0yNbRoZ1q3TELFRKjyfG23razyq3O7Og30n1g/yn33LC5T/sVTgB
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a fake series that I created to test b4 submit. It will be sent
to the patches list, but it's not a real set of patches. You can ignore
everything about it.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Suggested-by: Sockpuppet Squirrel <mricon@gmail.com>

---
Konstantin Ryabitsev (3):
      Add myself as ultimate maintainer
      Our version goes to 11
      Rename Linux into Konix

 MAINTAINERS | 4 ++--
 Makefile    | 2 +-
 README      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: 88084a3df1672e131ddc1b4e39eeacfd39864acf
change-id: 20220707-my-new-branch-1325e0e7fd1c

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>
