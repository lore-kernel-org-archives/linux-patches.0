Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949C5328B75;
	Wed,  8 Apr 2026 18:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673147; cv=none; b=PxCyPjFSs0tWIvvs/Eftm2gHUibo6t8WRmvCi9F8OZrMtKzSXCdQy3+G3LS0fJ3I3OTouNHvikDqANzAmDpQbE3Iwqb4Y7SvP1JrPbVPk8cT/j+YuoJa2c8RrvzHZP9p8Li+roEzHs1oaH6Ik2zBfU4qR9YvZ3tudGQJS9ds6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673147; c=relaxed/simple;
	bh=ol6xnRpMW0ni29WV/ggkCklhq2W5HrqiYQZkdYoyszQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCq6OV/UczG5RzIzMUjBeM9g6lKf91tFfxj08ebrrgzwUrO/bmhXca4bmhbudHdqNmUItSbVoHZTl4TFlz0R9Wp0Izu+A2KjljdfQ1FlWix7R4eL53rWCOwkz6hGKeBthichL+spVwjW8r5Gua1K/0j7nJRaHoQEQTAJhL/L8JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E94cv4BL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E94cv4BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C307C19421;
	Wed,  8 Apr 2026 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673147;
	bh=ol6xnRpMW0ni29WV/ggkCklhq2W5HrqiYQZkdYoyszQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E94cv4BL2hYJ7tmITHr1ze5sQ1wLVlc80F8F+0iVtZcTXWjpZ28pqMQ5RuHlpdn2x
	 6pnd4yaneUqv3A2d5gPMiizAvp5LX9fRds5O/2jLr9EstYMe/8d0lQgD4P+WodM/kE
	 qY/97HaQiO7nX1By/4cjHeYylIhhaeD255BGp4Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/277] hwmon: (occ) Fix missing newline in occ_show_extended()
Date: Wed,  8 Apr 2026 20:01:45 +0200
Message-ID: <20260408175938.353730058@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit 09773978879ecf71a7990fe9a28ce4eb92bce645 ]

In occ_show_extended() case 0, when the EXTN_FLAG_SENSOR_ID flag
is set, the sysfs_emit format string "%u" is missing the trailing
newline that the sysfs ABI expects. The else branch correctly uses
"%4phN\n", and all other show functions in this file include the
trailing newline.

Add the missing "\n" for consistency and correct sysfs output.

Fixes: c10e753d43eb ("hwmon (occ): Add sensor types and versions")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260326224510.294619-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/occ/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
index 89928d38831b6..86c79156a46b9 100644
--- a/drivers/hwmon/occ/common.c
+++ b/drivers/hwmon/occ/common.c
@@ -725,7 +725,7 @@ static ssize_t occ_show_extended(struct device *dev,
 	switch (sattr->nr) {
 	case 0:
 		if (extn->flags & EXTN_FLAG_SENSOR_ID) {
-			rc = sysfs_emit(buf, "%u",
+			rc = sysfs_emit(buf, "%u\n",
 					get_unaligned_be32(&extn->sensor_id));
 		} else {
 			rc = sysfs_emit(buf, "%4phN\n", extn->name);
-- 
2.53.0



