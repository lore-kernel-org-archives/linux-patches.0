Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D981E0E0A;
	Wed, 19 Feb 2025 09:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957109; cv=none; b=KifY3WNUwnZdB4sDr7lg5sF/9i43MsWct92iBBcglKs8r3LStbHon7Df04O8G8jd5xXEYNQofTpu6CkbEoS18vMc9nSmEwF5L2FPTqywtntYb/0s0lHFWEbSX434RkNQwIp6u/yxtAcANsZD1RP4XPm41A9/bhbu493ReC+5rJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957109; c=relaxed/simple;
	bh=AKMrUIMfKok5/uAY02lVSnwkcYfUjcCioxDVXpysDa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q76Q7pFZ3zdNmxQ+dD/qAdqfl0pnYMlmHGF0DxKguAQYJ8WAu49S1Yalzs5ByDyWjKiDtiMLnVQVGI91r8nhu+f1VCU6sxOQ4ZopTnau1Q2MX4W/CaPToWURooh1TOwNYH0j5HnFFBMXJtEUjRmwZdCOgeFFALitFTP2Mb5xdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ389cfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ389cfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D897C4CED1;
	Wed, 19 Feb 2025 09:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957109;
	bh=AKMrUIMfKok5/uAY02lVSnwkcYfUjcCioxDVXpysDa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ389cfC+o5YbROaPhmeTcsPZJdVJ3yIWkEq/RAWKNkK8k/qvJhak/mU0iKHXD1MK
	 uN2YWiv7gGbRbxXguKeRUWlofVTIRbGlT1lhqz9i0bB10UXRz4lDncE7SMuJjvVCra
	 RwXlTpUqQupgM+aOHTGe8JHteA7sDQjHBlBtU79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Bobrowicz <sam@elite-embedded.com>,
	Michal Simek <michal.simek@amd.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 411/578] media: ov5640: fix get_light_freq on auto
Date: Wed, 19 Feb 2025 09:26:55 +0100
Message-ID: <20250219082709.191579266@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1971,6 +1971,7 @@ static int ov5640_get_light_freq(struct
 			light_freq = 50;
 		} else {
 			/* 60Hz */
+			light_freq = 60;
 		}
 	}
 


