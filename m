Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A768330B2A;
	Mon, 29 Dec 2025 16:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025234; cv=none; b=Gd2GN3zWdCGjWPSVTzXUQXN1vTN7baK7k1r20d/6KfoNtTUYWlxomng7hH7nhwIzRpfpw2rZmnjc5MpUSWNYe/m5LiGnWK84DOpzxcVdYP3kGI9YOXmtf9kf9xqfjog+cSH67NfhSZI26+uFgbbtm53nFKsb1yMZa3d+pGA/w8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025234; c=relaxed/simple;
	bh=AjXtFuPk+MDeSQMvScDXsD70Tw+J/5buNVgewWii/Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iifw5vUUuAmu7LR0ZdPIXMebZ7/5Vsj4zEMB7xr+ySAG2rO6s6FfFHgD9ABmvRaQnrha7ux5XFPZ5UTPNeOic192x8X4p+m/RokjgAqc7RVEOOEVHIHJkxSR3pe15Ph+IS+ZVWUaaQOS+sYfIMG/CriwpU4lfHZKXPa6n2Ogctk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CISYdmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CISYdmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E08C4CEF7;
	Mon, 29 Dec 2025 16:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025234;
	bh=AjXtFuPk+MDeSQMvScDXsD70Tw+J/5buNVgewWii/Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CISYdmJgOKtovpPz4vBhCYgyDMYV1tSgKXXENsiFC724sPzgWjfWyNxn1r8nYHzj
	 U3B+QoPWcvr99YtEaqVugQAaYeyVDeTc4bK2OXsTdaOts9B1tPJ569BXh1gWuj0p6e
	 Hf6ETR6xHDsvHqklxZ2/TgxXnODdIUBpXdhFGlec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 142/430] hwmon: (ltc4282): Fix reset_history file permissions
Date: Mon, 29 Dec 2025 17:09:04 +0100
Message-ID: <20251229160729.588300914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit b3db91c3bfea69a6c6258fea508f25a59c0feb1a ]

The reset_history attributes are write only. Hence don't report them as
readable just to return -EOPNOTSUPP later on.

Fixes: cbc29538dbf7 ("hwmon: Add driver for LTC4282")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20251219-ltc4282-fix-reset-history-v1-1-8eab974c124b@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc4282.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ltc4282.c b/drivers/hwmon/ltc4282.c
index 1d664a2d7b3c..58c2d3a62432 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1018,8 +1018,9 @@ static umode_t ltc4282_in_is_visible(const struct ltc4282_state *st, u32 attr)
 	case hwmon_in_max:
 	case hwmon_in_min:
 	case hwmon_in_enable:
-	case hwmon_in_reset_history:
 		return 0644;
+	case hwmon_in_reset_history:
+		return 0200;
 	default:
 		return 0;
 	}
@@ -1038,8 +1039,9 @@ static umode_t ltc4282_curr_is_visible(u32 attr)
 		return 0444;
 	case hwmon_curr_max:
 	case hwmon_curr_min:
-	case hwmon_curr_reset_history:
 		return 0644;
+	case hwmon_curr_reset_history:
+		return 0200;
 	default:
 		return 0;
 	}
@@ -1057,8 +1059,9 @@ static umode_t ltc4282_power_is_visible(u32 attr)
 		return 0444;
 	case hwmon_power_max:
 	case hwmon_power_min:
-	case hwmon_power_reset_history:
 		return 0644;
+	case hwmon_power_reset_history:
+		return 0200;
 	default:
 		return 0;
 	}
-- 
2.51.0



