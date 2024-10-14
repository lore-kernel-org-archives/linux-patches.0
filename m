Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC991ABEB5;
	Mon, 14 Oct 2024 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918880; cv=none; b=q8JogXE6/rlQVP09O5Yw4lIfWEG74PWlQlIPcuP2dB6qJRVYLot0w/BMCIUs0nC5SeQF+iVeUI2W39vFavpyiOpNmZb+5AN8LowQ3ZfGCuy70Ii3a01AIelRF/5M61lNa+tPMDHGedJ5ZBLWptcqsswHukHieMXzurDNxw4Z/sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918880; c=relaxed/simple;
	bh=5fLtkjpqesAwkuAdh1lfvd2XICFMpMNOxOvfRtLFP58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro9zivx2IbVX7dKoTMFZaiq5TF62eNGE+K/1V4x8gWwJ4KYmifw412KgpRa332wLKZfL9LK5lAuYSxmDjizBpP4se3xG2C00z/U0jRIyixOBd3X3eySdSnPQxHW74q683+b1K6gnHfOxTqyMvZKO396TePykX3dXNdfXEOqnjNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8PTFdrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8PTFdrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112E9C4CEC7;
	Mon, 14 Oct 2024 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918880;
	bh=5fLtkjpqesAwkuAdh1lfvd2XICFMpMNOxOvfRtLFP58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8PTFdrlNQMDmpH+VtoWiFAa9WCN4UNaVM+k4XLFi297g/95zLmYG8vq8p87T0u26
	 ugg2rHn1uo49UQGJWPaE8Usu9/NctvN1Ma+VKigir53uNDhIOAN6dgzim/jkl2m4XV
	 od83G1Y2RVHYIVcwRvxfsPlhpZNO2kZ/N7Nm+gDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 449/798] ACPICA: iasl: handle empty connection_node
Date: Mon, 14 Oct 2024 16:16:43 +0200
Message-ID: <20241014141235.611214794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

[ Upstream commit a0a2459b79414584af6c46dd8c6f866d8f1aa421 ]

ACPICA commit 6c551e2c9487067d4b085333e7fe97e965a11625

Link: https://github.com/acpica/acpica/commit/6c551e2c
Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exprep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index 08f06797386af..4daef7530d91b 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -437,6 +437,9 @@ acpi_status acpi_ex_prep_field_value(struct acpi_create_field_info *info)
 
 		if (info->connection_node) {
 			second_desc = info->connection_node->object;
+			if (second_desc == NULL) {
+				break;
+			}
 			if (!(second_desc->common.flags & AOPOBJ_DATA_VALID)) {
 				status =
 				    acpi_ds_get_buffer_arguments(second_desc);
-- 
2.43.0



