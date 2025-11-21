Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1B71ADC97;
	Fri, 21 Nov 2025 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732950; cv=none; b=srHGyQ5KLC9Ty1aeACe+c96SEAOrLbkvJCTcoBHN9DNcg49dYGj85NaXg+wdVbRtSL3IlvdzOSeCFZcWzgFgPzRZm0yGG7YG0HgFIIDvSCRBBBUVS25WJY3eO0AA0XkiAnzmOWB38klVj2Zi72hnW2w+zEd+ZbHMagiutWaFMA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732950; c=relaxed/simple;
	bh=Ig9g/eyENrzUXEIk4foCWU2QXB0lyqtZbjP8q+/JkZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnUaNVbVuImKIWGdUvHwHPLptowyfZKVu/PObU1SqCgzQWZ9KUH+CzRhGQ983kDaXEW6rK41rZ0mFQo3N9xm9Y+/nxwvIVItdTJdCUd41I42xfwvccO9rtia14Z7kxSCOL/XIsrkNN5dJ0JZbWDU07QHU+snrS9+rf7DKGv3B6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5hISVwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5hISVwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F349C4CEFB;
	Fri, 21 Nov 2025 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732949;
	bh=Ig9g/eyENrzUXEIk4foCWU2QXB0lyqtZbjP8q+/JkZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y5hISVwHJQeca5+bDRvCl4EQnGtxk3dj8c7bsJYq3jy63e2J33kL/AJ+u6YqbhyNj
	 eljcB4c09Cm/gY4Bd4BPV9g6mc4wOO759nwAQonx1/n4ZGMz+HrBVoXMMVPdxg0ksg
	 A6c563hh11D9bY49RcLVG/QSZ2OxyyJ/LE4ZE5c4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 299/529] ACPICA: Update dsmethod.c to get rid of unused variable warning
Date: Fri, 21 Nov 2025 14:09:58 +0100
Message-ID: <20251121130241.665588828@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Saket Dumbre <saket.dumbre@intel.com>

[ Upstream commit 761dc71c6020d6aa68666e96373342d49a7e9d0a ]

All the 3 major C compilers (MSVC, GCC, LLVM/Clang) warn about
the unused variable i after the removal of its usage by PR #1031
addressing Issue #1027

Link: https://github.com/acpica/acpica/commit/6d235320
Signed-off-by: Saket Dumbre <saket.dumbre@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index dc53a5d700671..6168597a96e6f 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -462,7 +462,6 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	struct acpi_walk_state *next_walk_state = NULL;
 	union acpi_operand_object *obj_desc;
 	struct acpi_evaluate_info *info;
-	u32 i;
 
 	ACPI_FUNCTION_TRACE_PTR(ds_call_control_method, this_walk_state);
 
-- 
2.51.0



