Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559EF16FF26;
	Tue,  8 Oct 2024 13:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393256; cv=none; b=VJmdVVA99KM27PT7fI8pT4IjHfex7ulbxSzpbmIv641z+HPupZk7GPQ52jRohP+EkubpgY0BYkOMpURVaYGt1BxBppro/6a0tQ3PILEFJAHoM5JBQCU8Ch7IBUgryQDptI+wyDFNoW4I5qMI4aQgTzKe4ocT+cfnhDH3kHlJp0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393256; c=relaxed/simple;
	bh=2Sl/U0chRhACupt/b67Zy07yQGYR1OXUuuTXGyj5ccY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LHDPRHUfWF0sGB7YkRZwW8kERnHXZXtcKJv7DoeNH+tHlAZp/HtHT9dLPQMQCJ1HsGTrM1bpcwrZa/HqKNzkKc5lsohwiGG+8KNYAkcGjZ6bVW3+MeK1lPp2KQlZpMNtkYAiICyqidA040qbMLMwdPSyb65/CPv7gKhx3EQTqB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/7mwvjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/7mwvjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754E8C4CEC7;
	Tue,  8 Oct 2024 13:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393255;
	bh=2Sl/U0chRhACupt/b67Zy07yQGYR1OXUuuTXGyj5ccY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/7mwvjHErJ5z6HsliWz7HVwWy1jf0sJJ3SYBjv7mpLnsUglNg2zX/txJOfUPcRml
	 LGrJAppsv4pfJ45sZolkPTcnNNqUTfcdNGsojYN4LS0xqqp+zJRTEltqHloW16XGYE
	 Ry3GcTFSG4qts165xGrEFwSpPJZ61pbUVfuOV8G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/386] ACPICA: iasl: handle empty connection_node
Date: Tue,  8 Oct 2024 14:05:44 +0200
Message-ID: <20241008115633.343075242@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08196fa17080e..82b1fa2d201fe 100644
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



