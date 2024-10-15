Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DF31C07ED;
	Tue, 15 Oct 2024 13:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997879; cv=none; b=SYiDgP0VQoM1bXq+cQdXSi+leFLE0FOdq4zTDtNvlutGoAOl9kPN+rwEGTMLn8Hb9YFB07cWg9COilm1Rx6LmfRneCWJ/KAZTXmiWvXKjVUjKZBli7CDmJTIg+4fi2wM3EXZp9EIWMl7hwdsyNJ9yYx6Pl93r8POwtiOy8HhD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997879; c=relaxed/simple;
	bh=6FQTxizd681vuKm0hGgnMFESU9maBwGDfBCv/kyQR2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpCk1NLdmD6dqVHD0mf/29PfnOwcLEIoAzC5jJASglCabSYXY4qI76j726ad9+oIYJgum12sF3+IZGLdibz9Fcu3/ISzMfuSD/2tHHRwfmZdu/3aBT6rbnaTR0BqZMTiYmBPJyER1xmobsiKX+k7I6lexpR9wj6Ze+PdftjuABk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWJE9gd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWJE9gd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE624C4CEC6;
	Tue, 15 Oct 2024 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997879;
	bh=6FQTxizd681vuKm0hGgnMFESU9maBwGDfBCv/kyQR2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWJE9gd3dsPuUvVy+ZTpi4SqEU0tTqrDUHvcaqScmbsvi6vIJKypE79nKnHnDFLJG
	 EaVivhzCU9+hBdzs+Tjrpjf1tgGbw5Dy1HKFX3N1S3VWe+KYoeFeMbd5onVBP8Xibh
	 xQjJEPrtZx/HlDgFQ1xGesQ1RfY+WPsl+8GJErAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/518] ACPICA: iasl: handle empty connection_node
Date: Tue, 15 Oct 2024 14:43:39 +0200
Message-ID: <20241015123929.141138289@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4a0f03157e082..ab500f31c96e8 100644
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



