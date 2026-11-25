Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620922;
	b=e8xNtip51Ew7d9ZBl/vR+G4Llamjo5RP44hlhA0SdZpj+xNkSoah36tBaOrpGrjhVRNF
	 x8Za57QFOdb5y5ReZ6n/G0Y0GvwziPI3jav5np1OfSX4Gn74mRoEIj0tMEI3C/hc/7Upo
	 V+MlCgp0lTpFRVSVS2ldZAh0Ar3glx06nx/n4dtX7gGfcA7Hy3fklWVPKndk08aNOOYly
	 7J2gO0dsA3EV/ZGdT9kgXrjxqkD9E2h8GwimJivG9uV48b1vJaVbmHBRwd9b2k9w255AS
	 htukn38SfJMsTwFk1MA8Yff/oBAWXCyrocsxyTwhpXItyxFN28eKOCRvx+IjyqZ2L5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ecDt0Z9262A/5O/TBaXLY0zrs8X2qaOraGjbEwngtqI=;
	b=kXDL4XsgUW5SOuGmDOM5xSThunHZZL/9zpCcew1AfpL9UDUlX3OCNGbV5o6Pt6xhuon4
	 /jb0+R4VPRXQofZ6LVIHeZOTbclW4MPGzDJj97heVUMMbbXwlFb3Sx6Mc6hXPm877iby+
	 /nUfFvj+zaINgShwFYshV1f2iTylmjtw5yu2lBPsVKqrFvR48iI7RSXafKLkdFArZ0fPP
	 NCssdDBUCn4jzaLy/N7fV9oRoS8mqwTi9hjDE8XMfkaY35fleCI3YapAYRj/9B0ZGrazk
	 uydU5TMqbJMn9rYNNMxqZYd9Vu3+QcDY9Qt5GHIlSKwb2NLMmp8OA8K1Hqc9ZZPaPNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfcDVxOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F268D606A32E;
	Wed, 25 Nov 2026 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TfcDVxOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D41F000D1;
	Wed, 25 Nov 2026 15:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620921;
	bh=ecDt0Z9262A/5O/TBaXLY0zrs8X2qaOraGjbEwngtqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfcDVxOoSSgbWTR5qYJJBk2Hv3XxYo5/am+qlaN+synXE03/n06ksXve9SL1Ywukg
	 SzeLu8JQMEPGOK8XrezPi7W1Uh/pDvmvEHylF47yE4Fzh/X5EwFS15vsW3beVovwwC
	 LokkP9ytTr3JbnSz2a3704jN8tDZP7Ax+Z8pIg0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krittikun Wongnin <krittikunwongnin@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/990] ACPI: PM: Add Acer Aspire A515-53G to dmi_leave_unused_power_resources_on[]
Date: Wed, 25 Nov 2026 15:23:07 +0100
Message-ID: <20261125143822.562260637@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krittikun Wongnin <krittikunwongnin@gmail.com>

[ Upstream commit 8eb2754ef96d77d870d6b1ef1e0e8470c892b6b4 ]

On the Acer Aspire A515-53G (Whiskey Lake + NVIDIA GeForce MX230), the
dGPU behind root port RP05 (00:1c.4) falls off the bus during boot and
is unusable until the next power cycle:

  nvidia 0000:02:00.0: Unable to change power state from D3cold to D0, device inaccessible
  NVRM: The NVIDIA GPU 0000:02:00.0 ... has fallen off the bus

The firmware ships two SSDTs which both provide power management for
the dGPU:

 - One SSDT defines \_SB.PCI0.RP05.PC01 together with
   RP05._PR0/_PR2/_PR3 = { PC01 }.

 - A second SSDT defines \_SB.PCI0.RP05.PCRP (_STA initially One,
   _OFF calls \_SB.PCI0.HGOF, which puts the link into L2/L3 and drops
   the dGPU power enable GPIO) and its own RP05._PR0/_PR2/_PR3/_S0W.
   The latter fail to load:

     ACPI BIOS Error (bug): Failure creating named object [\_SB.PCI0.RP05._PR0], AE_ALREADY_EXISTS

As a result PCRP is not referenced by any device and
acpi_turn_off_unused_power_resources() turns it off right after the
ACPI namespace scan. This cuts power to the dGPU, but PC01 still
believes it is on, so its _ON method is a no-op when the PCI core later
tries to bring the GPU back to D0.

Windows does not turn off unused power resources, so the dGPU works
there.

Add the machine to dmi_leave_unused_power_resources_on[], like the
THUNDEROBOT ZERO which has a similar SSDT bug. With this change the
dGPU stays on the bus and the nvidia driver binds. Runtime PM of the
dGPU is unaffected, as it is handled through PC01: with no driver
bound and power/control set to auto, RP05 reaches D3cold and the GPU
comes back to D0 on resume.

Link: https://lore.kernel.org/r/CADS-TgDQ1G8vrTQLJeQ3RTBVFTyMe0C+5p2=UBKS=EFCDFuaxw@mail.gmail.com/
Signed-off-by: Krittikun Wongnin <krittikunwongnin@gmail.com>
[ rjw: Subject and changelog tweaks ]
Link: https://patch.msgid.link/20261013074245.4327-1-krittikunwongnin@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 2c0c982602014..4a67e9afdd7fc 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1151,6 +1151,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "NLCC 001"),
 		},
 	},
+	{
+		/*
+		 * Acer Aspire A515-53G: Two SSDTs both define power resources
+		 * for the dGPU root port RP05 ('PC01' and 'PCRP'). Only PC01 ends
+		 * up in RP05's _PR0/_PR3, so 'PCRP' is shut down on
+		 * initialization, cutting power to the NVIDIA dGPU behind the
+		 * back of 'PC01' and making the dGPU unavailable.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire A515-53G"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



