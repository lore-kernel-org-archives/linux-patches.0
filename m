Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD23325720;
	Wed,  3 Dec 2025 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779668; cv=none; b=ImWQXaiCH0ZhBukmVt9hjeG6udkiKPkqO3AzKIs69SoBXR8Wk5sviiOFB8SzmWLIRGtvBX3fZEHC2PVo8LG5d8C24MEemW/TpJTK0qiHiV92A94BgaQWdzsLq3CofDtu2ThnK/BHAmbmPBmCXlLlFyK/RQ7eprBaSoysca6NMMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779668; c=relaxed/simple;
	bh=AiuPprUpks0N6P8+MOFj4euys3j3qJV70aiIVnmmxYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e176NmnfuaGYSvger1sIDrG3EivkcjcI57v34Pzwydt57CrRjvKNp7fvk6CtY200xw9Q2Cw+gIEgyMcx9RNOFQkT4dRv6DbX+7bwUj2KgWQKsQJq2ey351n7Jcjj4DqOhjlK5+2lPvbSHB1vROE9Gwq0xOyfviXzTwLhg1rRcZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2DthmY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2DthmY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87554C4CEF5;
	Wed,  3 Dec 2025 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779667;
	bh=AiuPprUpks0N6P8+MOFj4euys3j3qJV70aiIVnmmxYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2DthmY6ItvQ2b7k8l1DmVCdMHZQ7G+SgqYqCzCNERsj9u366SmMOCDUJOEl5EbQN
	 P6ewCZ4LZ3HL6xyEBPemZT5GrHjicPPlLnqQfQDqRex6/0bhCwy4zz71brnsRUSHQn
	 pjrRinMUBbcLIAHzHn7iF4Nuoe7+pChULf6pJ8GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuta Hayama <hayama@lineo.co.jp>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 326/568] rtc: rx8025: fix incorrect register reference
Date: Wed,  3 Dec 2025 16:25:28 +0100
Message-ID: <20251203152452.651272862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -315,7 +315,7 @@ static int rx8025_init_client(struct i2c
 			return hour_reg;
 		rx8025->is_24 = (hour_reg & RX8035_BIT_HOUR_1224);
 	} else {
-		rx8025->is_24 = (ctrl[1] & RX8025_BIT_CTRL1_1224);
+		rx8025->is_24 = (ctrl[0] & RX8025_BIT_CTRL1_1224);
 	}
 out:
 	return err;


