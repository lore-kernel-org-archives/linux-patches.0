Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F83322537;
	Tue,  6 Jan 2026 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719961; cv=none; b=ssSaTCfWwNTxUCMaAy4BamDe7pe3ZUgfsQ/Q/5zTeBfJOoGkHCQJZeCERi/P1iY+mKmedBLvnhbh4A48fzkOSY99YQ/7wfZ9/+nqCY9ZcwwoT9Jhg0ZXjdGi95rA7vkNbG6A7rVlZFQF1zWdqGF455Q1Y4YkSRVHycua3APkAnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719961; c=relaxed/simple;
	bh=nkqvp8JJuqr9BW48y3m128IrKo6MvN03CO/zesJzQsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MbgHhHVIxc+EYeVexEnW7LTPlXLnxXFlO0Xeuymemre3eE8DiheaW2/pZLPSZk8mklUpHbsUB3uqq8B0vM4jGMQucscIq7v+genRgrhzK31PgEgJv/PZWzWho8DqnjSO7RPagoZi9+YI42ZZxVOMfes5UTQaQQzj8wfhx0hEE5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltW/R4nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltW/R4nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A57C116C6;
	Tue,  6 Jan 2026 17:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719961;
	bh=nkqvp8JJuqr9BW48y3m128IrKo6MvN03CO/zesJzQsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltW/R4ndxIXNwzapGbypAmrEeTCiC9+LP1pe2wrk/se+rhfjh9lVFJwnwVBOrquSs
	 xxZMmsUsWm+DFgiQ0DbhqZjVIq/IvRj4QzDab2JUfpGVqAAOtt5Tpbkc5jJy7/oimK
	 QGTfd3MAnCvR6Kf5evkH6kPDkA1sB7tzBScO1noY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/567] hwmon: (ltc4282): Fix reset_history file permissions
Date: Tue,  6 Jan 2026 17:57:54 +0100
Message-ID: <20260106170454.733138704@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 953dfe2bd166..d98c57918ce3 100644
--- a/drivers/hwmon/ltc4282.c
+++ b/drivers/hwmon/ltc4282.c
@@ -1016,8 +1016,9 @@ static umode_t ltc4282_in_is_visible(const struct ltc4282_state *st, u32 attr)
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
@@ -1036,8 +1037,9 @@ static umode_t ltc4282_curr_is_visible(u32 attr)
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
@@ -1055,8 +1057,9 @@ static umode_t ltc4282_power_is_visible(u32 attr)
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



