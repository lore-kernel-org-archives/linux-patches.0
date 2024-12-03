Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DC1EF0AE;
	Tue,  3 Dec 2024 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239338; cv=none; b=mx9AJU8tvZJTlbKg8cArbwPvcPJJzJCZ7TjP/f+DIqHqMeHi6bDsqTCSgOaVUoeGvDpQAmJ4TVB7ccvDqBQYO3JtM6n54QabcBuQ0MFDh/5nB0P8S8FMvVPPS0isY2NDdOPZKNkIC6Fc8tE1hkOiIXB1JoHZ5Z5J6A7DtUKjW+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239338; c=relaxed/simple;
	bh=vlbaE6QKV26YKi7rty3y8B6OvI2EgXIVkTNiJyGh3XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jog4l6UxdiqdWmPVN3OdonBaktSV2ZE3KIE/o0QvKJ3obxQ5RX87Gta0SzvFavsflU85ZaHzE/0pHw2DdDJiuak72jUXiBsAwh5Te1aHFkUdhOT6WlthUDalr8jviXoa2PeJWD96GeXhQv/ivBetX8hBz13rqbsz7bs/IRKVZ+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6chOKJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6chOKJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82585C4CED8;
	Tue,  3 Dec 2024 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239337;
	bh=vlbaE6QKV26YKi7rty3y8B6OvI2EgXIVkTNiJyGh3XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6chOKJHu4PGJFiOq9ziLiteFTHrpo2hwB61bXobCvtdSJ9ap6KFmBzUGhBhnn7Tf
	 1D3radxnQE5w6f501AqWHLzysLdOVSXG9uUe5JUXL/5j08pVmdqWrehwCBkx346Y60
	 Pi+os7QK5r9lZo97NbZWAY6zodtMlnu/LBTRuUcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arne Schwabe <arne@rfc2549.org>,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 548/817] hwmon: (aquacomputer_d5next) Fix length of speed_input array
Date: Tue,  3 Dec 2024 15:42:00 +0100
Message-ID: <20241203144017.297517308@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit 998b5a78a9ce1cc4378e7281e4ea310e37596170 ]

Commit 120584c728a6 ("hwmon: (aquacomputer_d5next) Add support for Octo
flow sensor") added support for reading Octo flow sensor, but didn't
update the priv->speed_input array length. Since Octo has 8 fans, with
the addition of the flow sensor the proper length for speed_input is 9.

Reported by Arne Schwabe on Github [1], who received a UBSAN warning.

Fixes: 120584c728a6 ("hwmon: (aquacomputer_d5next) Add support for Octo flow sensor")
Closes: https://github.com/aleksamagicka/aquacomputer_d5next-hwmon/issues/100 [1]
Reported-by: Arne Schwabe <arne@rfc2549.org>
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Message-ID: <20241124152725.7205-1-savicaleksa83@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aquacomputer_d5next.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/aquacomputer_d5next.c b/drivers/hwmon/aquacomputer_d5next.c
index 8e55cd2f46f53..a72315a08f161 100644
--- a/drivers/hwmon/aquacomputer_d5next.c
+++ b/drivers/hwmon/aquacomputer_d5next.c
@@ -597,7 +597,7 @@ struct aqc_data {
 
 	/* Sensor values */
 	s32 temp_input[20];	/* Max 4 physical and 16 virtual or 8 physical and 12 virtual */
-	s32 speed_input[8];
+	s32 speed_input[9];
 	u32 speed_input_min[1];
 	u32 speed_input_target[1];
 	u32 speed_input_max[1];
-- 
2.43.0



