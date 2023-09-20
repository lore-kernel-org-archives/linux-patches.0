Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4BB2AB22
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5E6C433CA;
	Wed, 20 Sep 2023 12:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211596;
	bh=qW8ptWzZzzKu6KU8wssYYiNKLXFxQranB3Ke9sU/z98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6OTw5gxBxcFo/5GHofdRn6I9F/qesw8orJQGlvKQikVuT81Pka187pS2KwvfrdUf
	 1ZioeKJjyAgCpAq+hVHWPwraAm0xOo8Wi/CDMM2KCqTtIqdO7GplQ8levnEZJD16sj
	 DIdyaHkaifVzO+pKXwiYsCzwI3ze8O+nulpwq6x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Mainkar <abmainkar@nvidia.com>,
	Bob Moore <robert.moore@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 151/186] ACPICA: Add AML_NO_OPERAND_RESOLVE flag to Timer
Date: Wed, 20 Sep 2023 13:30:54 +0200
Message-ID: <20230920112842.417464572@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Mainkar <abmainkar@nvidia.com>

[ Upstream commit 3a21ffdbc825e0919db9da0e27ee5ff2cc8a863e ]

ACPICA commit 90310989a0790032f5a0140741ff09b545af4bc5

According to the ACPI specification 19.6.134, no argument is required to be passed for ASL Timer instruction. For taking care of no argument, AML_NO_OPERAND_RESOLVE flag is added to ASL Timer instruction opcode.

When ASL timer instruction interpreted by ACPI interpreter, getting error. After adding AML_NO_OPERAND_RESOLVE flag to ASL Timer instruction opcode, issue is not observed.

=============================================================
UBSAN: array-index-out-of-bounds in acpica/dswexec.c:401:12 index -1 is out of range for type 'union acpi_operand_object *[9]'
CPU: 37 PID: 1678 Comm: cat Not tainted
6.0.0-dev-th500-6.0.y-1+bcf8c46459e407-generic-64k
HW name: NVIDIA BIOS v1.1.1-d7acbfc-dirty 12/19/2022 Call trace:
 dump_backtrace+0xe0/0x130
 show_stack+0x20/0x60
 dump_stack_lvl+0x68/0x84
 dump_stack+0x18/0x34
 ubsan_epilogue+0x10/0x50
 __ubsan_handle_out_of_bounds+0x80/0x90
 acpi_ds_exec_end_op+0x1bc/0x6d8
 acpi_ps_parse_loop+0x57c/0x618
 acpi_ps_parse_aml+0x1e0/0x4b4
 acpi_ps_execute_method+0x24c/0x2b8
 acpi_ns_evaluate+0x3a8/0x4bc
 acpi_evaluate_object+0x15c/0x37c
 acpi_evaluate_integer+0x54/0x15c
 show_power+0x8c/0x12c [acpi_power_meter]

Link: https://github.com/acpica/acpica/commit/90310989
Signed-off-by: Abhishek Mainkar <abmainkar@nvidia.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psopcode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/psopcode.c b/drivers/acpi/acpica/psopcode.c
index a402ad772a1e5..c561d35d441bb 100644
--- a/drivers/acpi/acpica/psopcode.c
+++ b/drivers/acpi/acpica/psopcode.c
@@ -637,7 +637,7 @@ const struct acpi_opcode_info acpi_gbl_aml_op_info[AML_NUM_OPCODES] = {
 
 /* 7E */ ACPI_OP("Timer", ARGP_TIMER_OP, ARGI_TIMER_OP, ACPI_TYPE_ANY,
 			 AML_CLASS_EXECUTE, AML_TYPE_EXEC_0A_0T_1R,
-			 AML_FLAGS_EXEC_0A_0T_1R),
+			 AML_FLAGS_EXEC_0A_0T_1R | AML_NO_OPERAND_RESOLVE),
 
 /* ACPI 5.0 opcodes */
 
-- 
2.40.1



