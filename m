Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585964;
	b=I7BxmfVI/1B4v8ntRzhOn0zja6tf1ztVrmcS+N2Lf5MMHGFdEyq4zB+n1bB9ixM7xvbg
	 mmMQEFbyEWhJrPB8zLBfsesKuwD8UXhv3uq6JiTJe+y7zCNAc69FZmr8wzWZCIpdt+Pl/
	 rP64kThHmsDy2+jvHW6rmbc9LDBbMtgEsDuj8hDN/wAnEUf6+DO5CitokCWXCmBZHdByi
	 eHuJPHL4C3g95wQpRYiyttc7d33InVnXZfNAZ5vL8Wg96Z8TK8eDOU+Xqs+acKdKV8xoH
	 zj1F5QxXU70iAj5GfbT0xuzxakhgEe02RzY0Jkg849Wy0zlM1g4AKboqu9eAeLIPy7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ku/0SRc3eB4c5mvDWtF9YcwDXX6MtAg367Q2RH0NU44=;
	b=T9aXLo2l1dB0tZXUo9GQiiVO6XZThAQx4UUCalP0jrcwaM4UiJYyzR6tr4mt6f1ddh6E
	 +aOUBrnxXuqd/J0VkLqL2etuqyy0DOrXW1uSurcg9EXKnik1M+/VOEQUXwKYvXbN0v0lo
	 qu7leMN+O/A184TjOtKqEQK6DqRZthQ11Igk+n4Xjd6WRhbbAMFdrQCUbD+x/uJ6KJ/kg
	 /47xtmugiwrTUiMyDm5Nxyysm9ruyA4IjjqH7YnIv1z7ExPjXbNrsnh0/80uRRn6VTwd1
	 7CU2fOHgTDvDZnifBCZUoiU1Cj81qk6Q6Q9VVdcwNCAe2z7InB8z5ABnJBKX/C+dOJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0nTgG9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EFA6072300;
	Fri, 13 Nov 2026 16:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0nTgG9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31DE1F000C4;
	Fri, 13 Nov 2026 16:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585964;
	bh=Ku/0SRc3eB4c5mvDWtF9YcwDXX6MtAg367Q2RH0NU44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0nTgG9EUE2qpfZrOmfFCGLLmFuZVjysyXwv+5puTF7csOAUzcZ1fi+O1FD+SCtYc
	 br0Y1ZUZW4O0rzjxpVtea+KOTrpI2y98xNaLK1mHA3yIvEnE3vJgacmR64AnJnHmNq
	 JJYkI7Q20dd0NJmY3Hwg7Up5wxWrVMDr+V/Yymzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 502/507] intel_idle: Adjust state names and descriptions for _LPI states
Date: Fri, 13 Nov 2026 10:53:26 -0500
Message-ID: <20261113153814.126529312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 4035247966859152a6523bc041f81cb9905695a5 ]

The value of the _LPI "State Name" field is used as the description of
the given idle state (that is, the value of its "desc" attribute in
sysfs) which is not consistent with idle state descriptions used when
the idle state information comes from an ACPI _CST object.

To rectify that, use the _LPI "State Name" field value as the value of
the "name" sysfs attribute of a given idle state and use the MWAIT hint
value from the _LPI register address value to derive the value of its
"desc" sysfs attribute in analogy with the _CST case.

Fixes: abc5c103c66d ("intel_idle: Add ACPI _LPI support")
Tested-by: Len Brown <len.brown@intel.com>
Cc: 7.3+ <stable@vger.kernel.org> # 7.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ rjw: Adjusted scnprintf() format string, tweaked changelog ]
Link: https://patch.msgid.link/6061409.DvuYhMxLoT@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/pm/intel_idle.rst | 12 +++++++-----
 drivers/idle/intel_idle.c                   |  9 +++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/pm/intel_idle.rst b/Documentation/admin-guide/pm/intel_idle.rst
index 996e5bd83c425..d1a6251790b80 100644
--- a/Documentation/admin-guide/pm/intel_idle.rst
+++ b/Documentation/admin-guide/pm/intel_idle.rst
@@ -145,11 +145,13 @@ for the other idle state types (C2 and C3) the target residency value is 3 times
 the exit latency (again, that is because it reflects the target residency to
 exit latency ratio in the majority of cases for the processor models recognized
 by ``intel_idle``).  The name of the idle state (to be returned by the ``name``
-idle state attribute in ``sysfs``) is either "Cx_LPI" (if it comes from ``_LPI``
-processing) or "Cx_ACPI", where x is the index of that idle state in the final
-list (note that the minimum value of x is 1, because 0 is reserved for the
-"polling" state), and its target residency is based on the exit latency value.
-All of the idle states in the final list are enabled by default in this case.
+idle state attribute in ``sysfs``) either is equal to the state name value that
+comes from ``_LPI`` processing (with the possible fallback to "Cx_LPI" if the
+state name is not provided) or it is "Cx_ACPI", where x is the index of that
+idle state in the final list (note that the minimum value of x is 1, because 0
+is reserved for the "polling" state), and its target residency is based on the
+exit latency value.  All of the idle states in the final list are enabled by
+default in this case.
 
 
 .. _intel-idle-initialization:
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index c5b65f7d7271c..ec951c148d4a2 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1905,8 +1905,13 @@ static void __init intel_idle_init_cstates_acpi_lpi(struct cpuidle_driver *drv)
 
 		state = &drv->states[drv->state_count++];
 
-		scnprintf(state->name, CPUIDLE_NAME_LEN, "C%d_LPI", index + 1);
-		strscpy(state->desc, lpi_state->desc);
+		if (strlen(lpi_state->desc) > 0)
+			strscpy(state->name, lpi_state->desc);
+		else
+			scnprintf(state->name, CPUIDLE_NAME_LEN, "C%d_LPI", index + 1);
+
+		scnprintf(state->desc, CPUIDLE_DESC_LEN, "ACPI LPI MWAIT 0x%02llx",
+			  lpi_state->address);
 		state->exit_latency = lpi_state->wake_latency;
 		state->target_residency = lpi_state->min_residency;
 		state->flags = MWAIT2flg(lpi_state->address);
-- 
2.53.0



