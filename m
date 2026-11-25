Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617631;
	b=yKYchrrhEx6HiWeJLDQSfMBjFGHfFf6xqCgIsG5/ugFZ6oJ9k/+tBVAtAKyanodcgza5
	 i5Z5yPR9vcfuOrn3Ib58BBTR72NGsCmrUco63hIh2q3Frlr9dU281aSm9A9yh/YASCLkr
	 8Da80oFwKpU7TcS1JQSP4HZ0snXL/E89nhDIt6glZuTPOb7m/mNFxtKSE/YmhwcETH1i7
	 SU5tf2xhMjquRltHz41XYQoMydYE+Ys33Tq7uGzqk5AG9szoQcxJk/AjNqlGtlb7+g3sO
	 bvEiG3HWkEqcsbC4UqvNEqUUQcq72DtfciRvUc1dUeEvHfSQ7q4MAWd+zS2ZzM7WnTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xloc1Kpy/yVhQO6YmRbNrOLcz/kEGhj5o2nM371FZfs=;
	b=mt9qcA5zSaAdsNKdFy6IWvrb9/0A22dzlOTsidK68UiN2LxcL8voD6I/kU1Mft92kVBV
	 U/UoXkXBONk7+jC5cC10gJkHAM3rOe9gNmScEJ3q+ThT7sHwKUZBpAibbyPzFAg32WI1Q
	 995F2xyyy/XkDqU5rd3ure/jEeTymT4AyIWTNcQ17ejpD6kaeer3JNv9gyILol1KNLwLL
	 g2ATZReFPDFLDR8PNTgWMepThG80z5DnP4efSJfab/4PSEoLCNGvUHVMVhVAQY75mTdVK
	 228+wImX+n6iDihuoNhnw95uYHtPHSiVZKCb5whOCBXIZSXs+10ocZzYM3ZoduP+4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyITLUWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C1606A321;
	Wed, 25 Nov 2026 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MyITLUWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B2E1F000EE;
	Wed, 25 Nov 2026 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617630;
	bh=xloc1Kpy/yVhQO6YmRbNrOLcz/kEGhj5o2nM371FZfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MyITLUWzUtvJa+yC3utQBGY05+3om9pjS5EQU+ETQfXJEFKxHtL6LFgb0UN9AKhvh
	 kU9njCw2T/nuvOfWApKu+G9oHuHslG0a3y7utchlV68LSLIpaI8n8xfxcedvEpndMM
	 kGbHckkYNzRqkrSVRKjUXgiowb4VKdF8xxFCXRF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krittikun Wongnin <krittikunwongnin@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0009/1005] ACPI: PM: Add Acer Aspire A515-53G to dmi_leave_unused_power_resources_on[]
Date: Wed, 25 Nov 2026 15:22:27 +0100
Message-ID: <20261125143821.956401654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 34b73f320b184..c77342a584f0c 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1146,6 +1146,19 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
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



