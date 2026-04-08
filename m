Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C4C2F39C2;
	Wed,  8 Apr 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674572; cv=none; b=Hfl2qlmYQgGy5+YgUrahsUZBIc7SHDW5XUx1rFJKoqQiymPAHwZazYoVp73U2kRvS/ywjgsxyKgYVlNMNCrXjvYIZYL8JG0l4Z8Ue7qfxvESk9c6m8nBYkc9WiYl0P1g+NEjeoZ9MTX5gwxbHV2/pi0uiYO+IOneMcolUoOW4g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674572; c=relaxed/simple;
	bh=nrgz6QTlb8DyX6F3DAhNIXOkSVATFKvtIAKwoWV48vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSdIlyDSbSe0gWodDB5usCgsQggUpUkYUBmUjMODxzr7Q8tzzAcSGq/lmztbz6gRH3Hxc8wYSlMV78hsuunqaSgPK+iYVVbDuAxuwJ0cHQk90qfiJ3Hfp3ANchF8VhxtTnQn+0Isn48hy1hf1Sej0DbWo4nxsU+m8s4pmfQtCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gtyc5OHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gtyc5OHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9890FC19421;
	Wed,  8 Apr 2026 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674571;
	bh=nrgz6QTlb8DyX6F3DAhNIXOkSVATFKvtIAKwoWV48vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gtyc5OHtSKTuijGmObYXB+yF6DuA9DJvPQvKIEXlVrys2xo2wJFBYLdebnGEBA0CQ
	 IVcokbzaLeoWRrLMJPwCc7LTlfeilfu7J3wWZGUBkeaodKL1HukENbI1bxX9QEzMg7
	 Ppd9OGk0md1uzDld+z0j+38gcwFKS/3YYxlVvXVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 150/311] hwmon: (occ) Fix missing newline in occ_show_extended()
Date: Wed,  8 Apr 2026 20:02:30 +0200
Message-ID: <20260408175945.009973562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



