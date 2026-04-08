Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DDD3A16A0;
	Wed,  8 Apr 2026 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672687; cv=none; b=f2sAoyubzFhEskhe4yfE8Pyy0LafBey+vT9YMoKhZvgOAbdCtv85EYkkqBDa6Qfwva0ML4QLodQ6f1+WXu7m81rj0e5FJUYauY8rgpz4gwRA+Ya8rC5802Eu5yv+QkyJnuvKzMB2zAzqqoWR9AHEPQcNxeXuCoEfI7EXoKoZkPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672687; c=relaxed/simple;
	bh=A9W2d3Mz9VpnM9Bn+wlPNyuMA3apDelPyHKnSS3zpN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvGQZaOWz79V6SUMnfA0KpoCqDKCrWV+qQcV+q106XDSUY7iwK/SwKAu8uxYE+l6uGqQsTpKHfLpNN+4unA6mgqr/z3vH5ATEPh3Wa2raDAWfP3XdDY5n4G42c6KUfUlEyg8BuUMOYYavoRaD8MNWJvSmzGBKM2+i0rR3R5Jvyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MI0j5wca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MI0j5wca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F20C19421;
	Wed,  8 Apr 2026 18:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672687;
	bh=A9W2d3Mz9VpnM9Bn+wlPNyuMA3apDelPyHKnSS3zpN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MI0j5wcaj9hGUU+/6QoJF6+QWRNpu5L7mviFYTM4Vm2gQniNXoEFQnTtGJ/Wbk7A5
	 6omxLyl8ajDn6XY+DnfvnO7tDa//8nYD1ksFIvp2FkYclu7syBbNemgM6oBsu6+6Hf
	 ADXOggqTovFl8Kb21llUvM3jNClUM9u+vEFATI1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/160] hwmon: (occ) Fix missing newline in occ_show_extended()
Date: Wed,  8 Apr 2026 20:02:37 +0200
Message-ID: <20260408175915.816944884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 755926fa0bf7d..c6a78436e9bba 100644
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



