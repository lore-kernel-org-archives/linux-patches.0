Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3721DF260;
	Wed,  6 Nov 2024 12:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895271; cv=none; b=rS0MPM+yj/K0noQmXXrJdK2Yjt7uCnx60+ILLaASzYn1mLgKXVnEdOByVtAW4pNTCo8hssYyGBrbM38jIP0qbTtiNfOBgXDmCj9bWM0IZWkp7UUnlkEKiBYtMYxNxVZoBx3aNNS+X3F7E42HB6JvisKCzxkEHUGaqzIykqkV/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895271; c=relaxed/simple;
	bh=6lH8lOjiIH/0eYM90d/dyeBfrkwj171xE9bQ/qe9MM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4F937JGlb2hIxmlaqFP4/EG6n1Z8QXKcpa8NES5UvYM3N5KzHR7wbMPgeOc+X56tsv5aCkvCDxQHFvG/T/Ryoa+anX5TudQRvU/wcwC1hKoJjl2F0+1cIJCMrJoNlVC2zTf99tDzF0RF72MyrYB1oKnLEhq+se5dkL51pByEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruuatcOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruuatcOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3705CC4CECD;
	Wed,  6 Nov 2024 12:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895270;
	bh=6lH8lOjiIH/0eYM90d/dyeBfrkwj171xE9bQ/qe9MM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruuatcOQYk7HymU42UEKKloQ57DD6p+uvGKO4614jN3pKtdtqLDPt2tAUFrQaK58G
	 eO5hcAWGXfyromF6pb+Ni8vQBsSjDL6myzP87WdD9lC6fE2O7pZGYqqf33yqylQSB4
	 P8ekNG6nXHOjGZsNbnNifmLWM/gpDTPZZN7NnIOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 160/350] ACPICA: iasl: handle empty connection_node
Date: Wed,  6 Nov 2024 13:01:28 +0100
Message-ID: <20241106120324.872670902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 228feeea555f1..91143bcfe0904 100644
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



