Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF422301;
	Tue, 11 Nov 2025 01:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824909; cv=none; b=q4gDqGh2cPEsq/rl46Q5IWfdIUpnC93H9m5UoNwsY0HcYYkY2oTySi5VOjLMUE/TTbdRY+rvNzRfhekhseG0UTIM53knRf2AsIaecgXgmhQqOSMU4cX+UUuYvnbxyIj5zBE7jcXCBZXA0EqpVDGLYTEEzNHFqwZINhV2Ux7mPM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824909; c=relaxed/simple;
	bh=0mrptI+EUp66Sl4BFC90xb7PufYf8srUllo8NzCKkwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYPbOD3CQvd1HCrAzkLz3q5ZeXSf4ToXPleoNaK8cNa90q8lp2YsEsFWIuHcubwU4AiXm9f2Ta10MhHK3Vo0kXPuMCFSph4gS6xS9+R+G4VQGz19CBTc/ibNQVsgDOe2pc7ukwVJCtRiXWOwa16HAueyW8pHhFajZj1fBFLFdCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEPEB57i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEPEB57i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B64DC4CEF5;
	Tue, 11 Nov 2025 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824906;
	bh=0mrptI+EUp66Sl4BFC90xb7PufYf8srUllo8NzCKkwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JEPEB57iL0TqvYeNxSnuA/jq36CS/nPMX7TwD3aRIe4EdFAEM5cbu8WAOFn1k2mQD
	 jx/bbHzt0RfFNTKf83CBSytnC+P8+crzN13KUM0/iLtdf5vsuzjcIEUNK4J71DHY78
	 tdU5+PbB2VhvLEQU7mBKmCu08JVPjzU/zrU8oS+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuta Hayama <hayama@lineo.co.jp>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 548/565] rtc: rx8025: fix incorrect register reference
Date: Tue, 11 Nov 2025 09:46:44 +0900
Message-ID: <20251111004539.323703237@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuta Hayama <hayama@lineo.co.jp>

commit 162f24cbb0f6ec596e7e9f3e91610d79dc805229 upstream.

This code is intended to operate on the CTRL1 register, but ctrl[1] is
actually CTRL2. Correctly, ctrl[0] is CTRL1.

Signed-off-by: Yuta Hayama <hayama@lineo.co.jp>
Fixes: 71af91565052 ("rtc: rx8025: fix 12/24 hour mode detection on RX-8035")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/eae5f479-5d28-4a37-859d-d54794e7628c@lineo.co.jp
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-rx8025.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -316,7 +316,7 @@ static int rx8025_init_client(struct i2c
 			return hour_reg;
 		rx8025->is_24 = (hour_reg & RX8035_BIT_HOUR_1224);
 	} else {
-		rx8025->is_24 = (ctrl[1] & RX8025_BIT_CTRL1_1224);
+		rx8025->is_24 = (ctrl[0] & RX8025_BIT_CTRL1_1224);
 	}
 out:
 	return err;


