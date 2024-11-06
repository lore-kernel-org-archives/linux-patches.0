Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF0C1E201E;
	Wed,  6 Nov 2024 13:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898358; cv=none; b=rqzvqhZqMt7SGJFG1eW+dAII0gR57HfD208cDsxIt29cflSxYlQdJvfa3Kk37kZY9xiep15gcKM4yBd+to5kUPW1x34clFeQ+wSwR/ebWT2EI2/262W1W0i4ohcWlo4aYwz/JLmUBo8t9FTrT5kCY7oSfslecBIrCYFcyc5DXWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898358; c=relaxed/simple;
	bh=QQ+5bjneJWHk4D0/GwpLtZyTW+PKas/BxABLZW6YxeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhpM3xLQ8r24ysGknyOiOu2vK86UeBz+fOpAw5DM2KykXdB20eqsKk8IqBiivbLAGxEaq7Ycx0ovskCzZ03N02HrC7pH/M0p63aT4xTEydsIAC0UAhrdG3RvVO8oA+doP/ToeLAzVXUmR1PTLJV95qgyuS00nBu3kxbmde8x2H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPLMfGSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPLMfGSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE56BC4CECD;
	Wed,  6 Nov 2024 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898358;
	bh=QQ+5bjneJWHk4D0/GwpLtZyTW+PKas/BxABLZW6YxeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPLMfGSKdsZwRlVdNV0IizZcI7q8F1O3zoW9EJK+Ue1WoakeXMdd7iGr+nET7Jz+V
	 QE75xwZZCcez2HJCohHleli+pPaTtLdttCQv7uUfgXd089Z1iXOFB6vAk5Erme3jW4
	 Ywt5hpZ5GN/drrTW32swHAdoc9RMZ5PIV2qKsrpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/462] ACPICA: iasl: handle empty connection_node
Date: Wed,  6 Nov 2024 13:01:44 +0100
Message-ID: <20241106120336.730560868@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 85f799c9c25c4..512a15d77d75f 100644
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



