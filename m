Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92786146588;
	Thu, 13 Feb 2025 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458183; cv=none; b=ETdEWd4+KzPcjLPjn5mZilmlcclZ3raONjkgG3QgdhcCEQIBif2FZi2dftKAVtY+Zvmp+6PRsUF3xvG2wp4WW96EOXrs0Fa7i4PHMemFD3Ak/CQLyPQI/aMSCeE6fTEyaB6qa+kGX+wyst5i9N/ZXsrzKqj54zsA74+/tEJgT0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458183; c=relaxed/simple;
	bh=Xa+6OXbSATOqWlGxXQ6WIuGf3DFWEKAEu3MLoxNUqOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTQLJHpUAJe5yKV89gALGMtpK6ttvjHDzCEhQ6nNMWMBumEeA+e1g3Le9CU7sTmEedZ3MWC+1tBHlkidG+eyEXdBxuJKjxEUAj0/B2BSWoD18WIFDkOaFtPCTGltqfnz28MZ2ezvGpA9nsrr12qbw+a3vzwcbmDm7iO2ufNtAaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7fSMy9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7fSMy9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00335C4CED1;
	Thu, 13 Feb 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458183;
	bh=Xa+6OXbSATOqWlGxXQ6WIuGf3DFWEKAEu3MLoxNUqOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7fSMy9Wuk0GOcB13gZX5Oja/3au6XQrbVY0owCOAvepy88Us5ahJeemkxT/oJD6A
	 NT0H7vaiH48frWrJugNxS8u3+xf6Vx0hBahSjHn2iKRmYmv/7IOY3BDyxd2zTWhb8E
	 fDr47SGiq4SnOVbPYyCVwA7aqVEdkG9YDQwRBo1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 326/422] media: ov5640: fix get_light_freq on auto
Date: Thu, 13 Feb 2025 15:27:55 +0100
Message-ID: <20250213142449.133699419@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1982,6 +1982,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


