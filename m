Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2F13AD50A;
	Mon, 23 Mar 2026 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274917; cv=none; b=YYgQ+r4g40uiE/vdCgkL51Cx+PI9ucIhFGDJcd/0xwvW5bpZRn2Y8wmKB2vx5vagteseb8davLiVOR+CwUh4VdwcrdeNVT0zS1W6QB9lG7g9meodEoLi66yQonxSKXu0jFsPqw4ypnYo2nQXhwC+2K6jkOtk600q5YHn+m1VGos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274917; c=relaxed/simple;
	bh=0bZzcpCHdpn5+zdv5T6JYBcOPKR5qlXXyigTAQIAN2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAta2HUEc7G3EzImM9YFwmUGUtWGrbdsj85HB7m6AJE+YK2H+yZC9HNY3XlgJCoYFRlMvFqvXOFnBKxGJJi4Tb7Q8aP8pi77q7FSQsMsBvlOZslRCm3L1KUXl3WYFFd4mgNgulrToX2yELqTWU1MOR0WYNezvcMGNVRyfIcgndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntysGZ6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntysGZ6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0562EC4CEF7;
	Mon, 23 Mar 2026 14:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274917;
	bh=0bZzcpCHdpn5+zdv5T6JYBcOPKR5qlXXyigTAQIAN2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntysGZ6g5LT8tc8fAjsKMED8Q+/i64vdPU8VoKSXSUhvvhHtbCeQRt6QgtasrMyvu
	 2xfVD21GVM6kzVcqeIV3rGFb+kMlMPPhMylk7fxFljH+/Hvm3coh1H6Y0u1Eld1Mwj
	 tr5odOG+p1aP4hA5R0zuWgPaDTy8BvahlCp3whTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Dumbre <saket.dumbre@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/212] ACPICA: Update the format of Arg3 of _DSM
Date: Mon, 23 Mar 2026 14:46:16 +0100
Message-ID: <20260323134508.658176580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Dumbre <saket.dumbre@intel.com>

[ Upstream commit ab93d7eee94205430fc3b0532557cb0494bf2faf ]

To get rid of type incompatibility warnings in Linux.

Fixes: 81f92cff6d42 ("ACPICA: ACPI_TYPE_ANY does not include the package type")
Link: https://github.com/acpica/acpica/commit/4fb74872dcec
Signed-off-by: Saket Dumbre <saket.dumbre@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12856643.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acpredef.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/acpredef.h b/drivers/acpi/acpica/acpredef.h
index da2c45880cc7e..c9e65c6a20690 100644
--- a/drivers/acpi/acpica/acpredef.h
+++ b/drivers/acpi/acpica/acpredef.h
@@ -450,7 +450,7 @@ const union acpi_predefined_info acpi_gbl_predefined_methods[] = {
 
 	{{"_DSM",
 	  METHOD_4ARGS(ACPI_TYPE_BUFFER, ACPI_TYPE_INTEGER, ACPI_TYPE_INTEGER,
-		       ACPI_TYPE_ANY | ACPI_TYPE_PACKAGE) |
+		       ACPI_TYPE_PACKAGE | ACPI_TYPE_ANY) |
 		       ARG_COUNT_IS_MINIMUM,
 	  METHOD_RETURNS(ACPI_RTYPE_ALL)}},	/* Must return a value, but it can be of any type */
 
-- 
2.51.0



