Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AFE4C97;
	Tue, 11 Nov 2025 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822271; cv=none; b=XwDKLACZqImu92PTFfgytO/jYgqk9Z/Rw2coxm8Of15SRNs9TxQT8tH4Q4jUq8/UM49kNP52B006cZeqabsB0ZaGmuwZzUNxgdymoX3Fiby94eocFqTPtbwPTKsCMp8zs4WSoJXwstCiJNvacw5bUxDyLeqKkGD1hDc3iNSiKMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822271; c=relaxed/simple;
	bh=D0qnVgigPLDNTSnOHEaS4QmAALhCWwnd+hi6sbhlawg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BePhaDS7FiVpIPPo+LpO1h9+FaQt4kGdWvyUk4wOx4ytRhJyhnirJIbIZck5hDrADLGPAwe0DSmc+Cgzg09rb80SYQNj+drmMwHZLgKdO7YCUQITOLpODUasnI9Z44YbYlrn8coAhN4yaxFomkvxv3dzz7NJNjvZqmZSXct2vDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcj94vco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcj94vco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF95C113D0;
	Tue, 11 Nov 2025 00:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822271;
	bh=D0qnVgigPLDNTSnOHEaS4QmAALhCWwnd+hi6sbhlawg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcj94vcoDgAfvVYeph9D3LjDtHoDowiLOEyTcvZW8wA5LU+sKJ1s1KI9otQn7w8Pn
	 d76bUzyYnOczxSHXIzYtbQYwKoDrINHtjIO/8r1QqOqwITgGrYp9n78ufEV77TQ6Nt
	 8fjc9iDrTrjvcbf4OQhf8as07ZPs25zMQOubw8b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 070/849] ACPI: MRRM: Check revision of MRRM table
Date: Tue, 11 Nov 2025 09:34:00 +0900
Message-ID: <20251111004538.118947355@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit dc131bcd8d9219f7da533918abcb0d32951b7702 ]

Before trying to parse the MRRM table, check that the table revision
is the one that is expected.

Fixes: b9020bdb9f76 ("ACPI: MRRM: Minimal parse of ACPI MRRM table")
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20251022204523.10752-1-tony.luck@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_mrrm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index 47ea3ccc21424..a6dbf623e5571 100644
--- a/drivers/acpi/acpi_mrrm.c
+++ b/drivers/acpi/acpi_mrrm.c
@@ -63,6 +63,9 @@ static __init int acpi_parse_mrrm(struct acpi_table_header *table)
 	if (!mrrm)
 		return -ENODEV;
 
+	if (mrrm->header.revision != 1)
+		return -EINVAL;
+
 	if (mrrm->flags & ACPI_MRRM_FLAGS_REGION_ASSIGNMENT_OS)
 		return -EOPNOTSUPP;
 
-- 
2.51.0



