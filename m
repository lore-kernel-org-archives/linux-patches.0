Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D0C8C13
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 16:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E054AC433C8;
	Fri, 23 Jun 2023 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687539153;
	bh=ECJadu6Wv0hnvlkw5Or6GfU2DtjVfIVP9DSqisQH1Rw=;
	h=From:Subject:Date:To:Cc:From;
	b=NN4Tq0/NdVAP0l76sLuiAbV5MDJTjhvwEKPgpJAejooXCdOufp3LHPAZDNt14Ew85
	 RgS5LRn9RyKuCmSiIOzRWx/kvQDzJjwV/LBYR650aEDIG60fBwjGYvvSx7+fUIG8BV
	 QErIMw+p61AZLs5BdHmpUFZfPxmodp3usaPt1OgM=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: [PATCH WIP 0/2] b4-test: test series to troubleshoot prefixes
Date: Fri, 23 Jun 2023 12:52:05 -0400
Message-Id: <20230623-test-resend-prefixes-v1-0-4fe9a056ff8c@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALXNlWQC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI2MDMyNj3ZLU4hLdotTi1LwU3YKi1LTMitRi3UQTY/Nk87QkIDRUAmqFSQB
 1RiuFewYoxdbWAgAvEj3PawAAAA==
To: patches@lists.linux.dev
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
X-Mailer: b4 0.13-dev-87aac
X-Developer-Signature: v=1; a=openpgp-sha256; l=516;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=ECJadu6Wv0hnvlkw5Or6GfU2DtjVfIVP9DSqisQH1Rw=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFKmnj0vcX6R37wXucJJT47b2Gu9uKq50dn3vWBr2dOnV
 57klJ643lHKwiDGxSArpshSti92U1DhQw+59B5TmDmsTCBDGLg4BWAim2wY/ucePFy0gpspncmQ
 dVeIi3fDjUa3heuqtu75lrnxxnUR5Q0Mf3h9tSRUUm6H/zWZyrBhle1tbeZVqZNO7GTZUi14w6w
 khgcA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

This is a bogus series used to test b4. Please ignore.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
Konstantin Ryabitsev (2):
      README: rename Linux to Lunix
      COPYING: rename Linux into Lunix

 COPYING | 2 +-
 README  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
---
base-commit: 45a3e24f65e90a047bef86f927ebdc4c710edaa1
change-id: 20230623-test-resend-prefixes-a437c7fbfbf1

Best regards,
-- 
Konstantin Ryabitsev <konstantin@linuxfoundation.org>

