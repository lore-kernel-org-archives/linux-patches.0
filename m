Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5342309B9;
	Sat, 14 Feb 2026 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104430; cv=none; b=Kecmw6VJdob8S2sK2vIp43ZRTTw7js9U6c0FGEUP9zhVFuN6ysDg8wtahL+bReVr10/X/AS41GeULqPp1bFLAXpsRADqolDLxqt7i/oETGk1C7YWiqwH5E97Vbg4OxzNGy+lmmMBOsNB29KZGeOBwiVLF5mBhE8XtEszuVOrFjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104430; c=relaxed/simple;
	bh=OgEjKhETvcMSKMrbsA06bj5t7WNQLC+beWujquJn9II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZQyK7Jsggh93jkWRSzDwuIIS6z/R9vGNGKzlvgkG0jKjbIz4IOD4OXhxbjrApVH+yPPOJJwbysxs/tUzWR4FOX9w3kbnBE7QdGmBxzUhinPCpmhlKmViAskIS0HuhYYy9jXmxIf7lDzTTNAaYe7sN3jU1MPB8+/tdT/qWZ1MfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgbMLOER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgbMLOER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05728C16AAE;
	Sat, 14 Feb 2026 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104430;
	bh=OgEjKhETvcMSKMrbsA06bj5t7WNQLC+beWujquJn9II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LgbMLOERaiJukSdpoYqXeQK80m1fp7ebUI9lETrorRK7GE0hwz1jp0CkR4cnEEqB2
	 +vml/ciAafnk7WAukAPIDzCVh60Fp0YmRrjsz7Bj43ukRB793WDiegM1RzHJC7GMGq
	 A2/WOXyP116ZBoeew7HhEfZ9HIOoLowyn9qUbmAwiTmaUNXZBMT7Z2AgH2T+3e9QZH
	 G6T6ytbJAXGEMa/80IleBycwokkSK4YJHJ3c1VK9E9HZ68vLJ+UkjPN3r9MeI05DkK
	 D4tdZiZ8VYjdffZ561xALxlb55zd3Y/SYgXn2iZ+pxBbDhXL0tC/0WachSzGwQNdhc
	 X40GOVCpLARnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.co.uk>,
	Babis Chalios <bchalios@amazon.es>,
	Takahiro Itazuri <itazur@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	dwmw2@infradead.org,
	richardcochran@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ptp: ptp_vmclock: add 'VMCLOCK' to ACPI device match
Date: Sat, 14 Feb 2026 16:23:44 -0500
Message-ID: <20260214212452.782265-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit ed4d23ed469ca14d47670c0384f6ae6c4ff060a5 ]

As we finalised the spec, we spotted that vmgenid actually says that the
_HID is supposed to be hypervisor-specific. Although in the 13 years
since the original vmgenid doc was published, nobody seems to have cared
about using _HID to distinguish between implementations on different
hypervisors, and we only ever use the _CID.

For consistency, match the _CID of "VMCLOCK" too.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Babis Chalios <bchalios@amazon.es>
Tested-by: Takahiro Itazuri <itazur@amazon.com>
Link: https://patch.msgid.link/20260130173704.12575-6-itazur@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit adds a new ACPI device ID `"VMCLOCK"` to the
`vmclock_acpi_ids` match table in the `ptp_vmclock` driver. The commit
message explains that this is for consistency with the spec - the `_CID`
(Compatible ID) of "VMCLOCK" should also be matched, in addition to the
existing hypervisor-specific `_HID` "AMZNC10C".

### Code Change Analysis

The change is a single line addition:
```c
{ "VMCLOCK", 0 },
```

This adds one more ACPI device ID to the `vmclock_acpi_ids[]` table.
This is the classic "add device ID to existing driver" pattern.

### Classification

This falls squarely into the **New Device IDs** exception category.
Adding an ACPI ID to an existing driver is one of the most common and
safest types of stable backports. The driver (`ptp_vmclock`) already
exists; only a new match ID is being added so the driver can bind to
devices presenting themselves with the `VMCLOCK` compatible ID.

### Scope and Risk Assessment

- **Lines changed**: 1 line added
- **Files touched**: 1 file
- **Risk**: Extremely low - this only adds one more entry to an ACPI
  match table
- **Side effects**: None - this cannot break any existing functionality.
  It only enables the driver to match against an additional ACPI device
  identifier.

### User Impact

Without this patch, the vmclock driver will not bind to devices that
present with the `VMCLOCK` _CID instead of the `AMZNC10C` _HID. This
means virtual machines using the generic "VMCLOCK" compatible ID (as
intended by the spec) would not get vmclock functionality. This affects
users running Linux guests in hypervisor environments that use the
standard VMCLOCK ACPI identifier.

### Stability Indicators

- **Tested-by**: Takahiro Itazuri (Amazon)
- **Signed-off-by**: David Woodhouse (well-known kernel developer) and
  Jakub Kicinski (networking maintainer)
- The change is trivially correct - it's adding an entry to a static
  const table

### Dependency Check

The only dependency is that the `ptp_vmclock.c` driver must exist in the
stable tree. This driver was added relatively recently, so it may only
be present in newer stable trees. Let me check when this driver was
introduced.

Looking at the context: `ptp_vmclock.c` is a relatively new driver. If
it exists in the stable tree being targeted, this one-line device ID
addition applies trivially. If the driver doesn't exist in a particular
stable tree, the patch is simply not applicable (and not needed).

### Conclusion

This is a textbook device ID addition to an existing driver:
- One line, zero risk
- Enables hardware/virtual device support for users who need it
- Already tested
- Falls under the well-established "new device IDs" exception for stable

**YES**

 drivers/ptp/ptp_vmclock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ptp/ptp_vmclock.c b/drivers/ptp/ptp_vmclock.c
index b3a83b03d9c14..cbbfc494680c7 100644
--- a/drivers/ptp/ptp_vmclock.c
+++ b/drivers/ptp/ptp_vmclock.c
@@ -591,6 +591,7 @@ static int vmclock_probe(struct platform_device *pdev)
 
 static const struct acpi_device_id vmclock_acpi_ids[] = {
 	{ "AMZNC10C", 0 },
+	{ "VMCLOCK", 0 },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, vmclock_acpi_ids);
-- 
2.51.0

