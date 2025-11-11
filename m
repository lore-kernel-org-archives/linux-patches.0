Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C7C41C69;
	Tue, 11 Nov 2025 01:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825461; cv=none; b=brWk/oYfUJGJIfWotOOuphWy5mfHzesCFDw3mjKcVMyZF0iXDTKbiFNhfw7aJnGQCGK+PbNYCgrQGlIYkvWSEIkVhJGPwMg+W7RTBQgjYriTv1WRljUzM0m/rzl3LbGO0GBf+Z3UU24KdpU/7eSAb9nOdl2xthCU4bhp2WBDrIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825461; c=relaxed/simple;
	bh=wbo4RVQOp9vVJhMHZNAAY8VEUDWaqtep6HxFWye/DFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZFo+kSpIpoP4hf6w1fDYhysGplPigZpCL4vGH5hP6zYIpPXdr8/6OkJ8JqCINGtW0H1BwPmxsbKtldLzb2PlPm0otigJaPTiRWJFI+SaoruO1cUUonyLn2H9p+DZcLfczRqyZgPdvmtY0AJLQQzNjmOA46kO1eDtt7dKZZKSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLayj1Mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLayj1Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3D3C113D0;
	Tue, 11 Nov 2025 01:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825461;
	bh=wbo4RVQOp9vVJhMHZNAAY8VEUDWaqtep6HxFWye/DFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLayj1MoiADmsj7ZnpI76lJlh7Alk1eq2y1oV7dtz+qv0egX0W0izwtLa6/eDe6c7
	 F+ZTtAuQHYBpKNgSbFMViMiHmhJnT4I9vllosIuhk0YhOO7Y8My4uPLUBwbjKvDXA6
	 bN9lflaNd5AFixSKwBGaKWGTZgTo9ck+mjF/cc8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuta Hayama <hayama@lineo.co.jp>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.17 813/849] rtc: rx8025: fix incorrect register reference
Date: Tue, 11 Nov 2025 09:46:23 +0900
Message-ID: <20251111004556.080639642@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


