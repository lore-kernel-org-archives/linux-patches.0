Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C0E190663;
	Tue,  8 Oct 2024 12:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391622; cv=none; b=PfWY43ZJu4H8LicJoSbXHEEa/IGgnXsXuR8CPZOoA765fuFTu1XhHK/L4cmwS6ueTHIweXtfBoxRXAJkUJWKfH1vb1/x1Dspdli8kXoJ76vu6Bpx7f6TFaVtOPGhz7vdvVyGqKVSg6LRf1qzXyn+oa4OzYttB22dflgrZjBsjnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391622; c=relaxed/simple;
	bh=xrumUxppdiSEK5S3bO83oZlO6dpdS2z6iEGAztiuGYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyKnt8QQmHaau6j9UjfK8IHcV2tEmQuDlElVMHhIgzsyh/2o2qmhA2tj8tjdaFkEBykh75cXoiO5FsqH0hrvxc2OgiSlcGx7Dibkmv4K4FWEwxyYDXM99h8IqUfkr527KoYV4/nCvfpPYUPjKzEhSDU/0YY60j0Se1IBhVxCS6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9kE2P2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9kE2P2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578A2C4CEC7;
	Tue,  8 Oct 2024 12:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391621;
	bh=xrumUxppdiSEK5S3bO83oZlO6dpdS2z6iEGAztiuGYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9kE2P2x3qNGSVpByPBVr1q/b8RR1BIKlo0cXEqI2Zd+k/5mUlbsHvUq4c8GKXRYG
	 0RgRR3Qrl1B1nHB+0fBZgibAlm52d7D+3joMTNPyKABUzn46hN7wawGqqwioTkZAMJ
	 0t5d97w5m+LgQ5fWhsNK4y8TUOYdn0VvZA/2+OQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 142/558] ACPICA: iasl: handle empty connection_node
Date: Tue,  8 Oct 2024 14:02:52 +0200
Message-ID: <20241008115707.952195347@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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



