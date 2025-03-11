Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DE625C70A;
	Tue, 11 Mar 2025 15:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705813; cv=none; b=CYvbyGd+f9r8L7yHeywewGtMmVjkav34WT/gVwcX/1j4f2SNKCU3s3DuJNFu6NN8grngEXh2cxbpgYwRlFDcSxvj3FUHxHqUS5t3pKmGzCMgzyFztkOWVawjofOMB3TgZqbT4pqCfT83LBfOzu3Q5b1Qb9pf8t42o20kl7X4omE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705813; c=relaxed/simple;
	bh=lxwsi0dDWyMwaJXHr2Cih7IEeJ1RbazRuTL2h3zEDuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuhzecA+axln7qF8vjrYuEK7ZWIHA7mWhMMruVvxkRZfg8LAYCDo4RMXfafYYdFaPwIs/GM37/AYvPkuNMc+9XVA4dIilsXpnoqaMlLXv7JKL8LkFGyl1uQpkCtuFij+vp6G7tM96n+C3+SqYmbXI3uhWvDU+AiYNz6hRUb5m8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BveDX+K4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BveDX+K4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8C2C4CEE9;
	Tue, 11 Mar 2025 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705813;
	bh=lxwsi0dDWyMwaJXHr2Cih7IEeJ1RbazRuTL2h3zEDuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BveDX+K4kWT1jh1Hv2nSvB4dAWvB6ePDznjdftnDTn1P3xXzyhyctknNQQqlHVuU7
	 7ifoQNZ2HoonthNVtSWG5a7mRz+p4MqJC0Ri/1TtbzEiaHfFcr8SW0WU55TTVDn4Qh
	 KZkyWITiDz09F8JUiP1CrgQUg855wWvK33tQ/qlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 145/328] media: ov5640: fix get_light_freq on auto
Date: Tue, 11 Mar 2025 15:58:35 +0100
Message-ID: <20250311145720.671428648@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bobrowicz <sam@elite-embedded.com>

commit 001d3753538d26ddcbef011f5643cfff58a7f672 upstream.

Light frequency was not properly returned when in auto
mode and the detected frequency was 60Hz.

Fixes: 19a81c1426c1 ("[media] add Omnivision OV5640 sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov5640.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1368,6 +1368,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


