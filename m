Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617627;
	b=Es+KjSOJG4v4xDvJIjx/V9Fu8eFxTuRsVy9JJT4NYF+vaw5D1aY7lGFzHK7Z1DizBxN1
	 sv5M1BcOp0rnczhKuLKII/m8KzR4lShsC51HhBwaEmZ5irZpsH1OGK+USzFNgyRbYdyjO
	 jLJR/b+DqZTY9YJ6d6DBPUvhetu44G4XU6HljruvXDGijlEBaeHmRDUEi29BDoBO0mZ0s
	 1FdjOT9dO7HAdxodQGvYvEHYfsSCj9Hd7l0Wxmw5kjKMFwhV2/DnZmG6634DvZOqYBgIy
	 b7+spBQjcqsGBgZ/jG5I4c/5CNhci7LujuhDw+IEu1fBmBzJi1EU3h8VCzsx7L6ranw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z7RxFP4GpoQkqENXVKKArdiP7ka1zoJcPQVGhHj7Oz4=;
	b=Ox0N112MctnHddoVLi8cNNO7iccT5wpLuwim3TwHkUC7EmX3msLw4SBMxdGeSsI/bCSX
	 AGG2k7sWVToFP/KgX0nBFdoQD5nqabMEzfGLV4Qh5uqhH6KhDEBX7NrCaGOr/22zkH7um
	 mJ1wTsEZSc8kShBeUzkkm52SHK5xVPyoADEETbMz110xUmIVkDVSkSnyhoFRlwYXH9A0Z
	 GbhkcXdtXJqy1f76RhhDbTTlaZzfecrRpw/QwhF9iA+0DUAyLnRiqvCBNUndAClRUzShv
	 tNPLjedexZOu7t8zNcn/yi+3XF21aFsmXyWs9oCASAfgwL2bMTFxRsf+/AQS5QQkfjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmS0bMjy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B62606A329;
	Wed, 25 Nov 2026 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmS0bMjy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80191F000F4;
	Wed, 25 Nov 2026 14:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617627;
	bh=z7RxFP4GpoQkqENXVKKArdiP7ka1zoJcPQVGhHj7Oz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmS0bMjyTbsrZE9GC6itKofOHM3FK6x8T66Nq3UX1V1XhjOLHbFE3XgRzSaPWKAMh
	 iUIxdSQqYnWYvlvbWjsodzrLfWkfKMbBCPcmXJ97LOa5nzOWote14bvwdD/4MUkSvu
	 lIRNM5kGh1dDv+9t1yDxkY2fBy7wf541wNk0u7Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hakan Abay <hakan.abay84@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0008/1005] ACPI: PM: Add unused power resource quirk for Casper Excalibur G900
Date: Wed, 25 Nov 2026 15:22:26 +0100
Message-ID: <20261125143821.933692180@linuxfoundation.org>
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

From: Hakan Abay <hakan.abay84@gmail.com>

[ Upstream commit 23ec17231cc6a83bb11d8660db5bfc5336f53a0e ]

On the Casper Excalibur G900, the NVIDIA discrete GPU and the second
NVMe device become inaccessible when unused ACPI power resources are
turned off during initialization.

The failure is similar to the THUNDEROBOT ZERO case addressed by
commit cd7ef20ba8c6 ("ACPI: PM: Add unused power resource quirk for THUNDEROBOT ZERO").

Without the quirk, the NVIDIA GPU and the second NVMe device are left
inaccessible in D3cold and attempts to transition them back to D0 fail.

Add a DMI quirk for the affected Casper Excalibur G900 with NLCC 001
mainboard to leave unused ACPI power resources on.

With the quirk applied, the second NVMe device remains accessible. The
NVIDIA GPU can enter D3cold while idle and subsequently return to D0
for accelerated rendering.

Link: https://bugs.kali.org/view.php?id=9891
Signed-off-by: Hakan Abay <hakan.abay84@gmail.com>
Link: https://patch.msgid.link/20261005174939.53873-1-hakan.abay84@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/power.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index c6955d1ad29db..34b73f320b184 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -1134,6 +1134,18 @@ static const struct dmi_system_id dmi_leave_unused_power_resources_on[] = {
 		}
 
 	},
+	{
+		/*
+		 * CASPER EXCALIBUR G900 laptop: Keep unused ACPI power
+		 * resources on to prevent the NVIDIA dGPU and NVMe #2
+		 * from becoming inaccessible.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CASPER BILGISAYAR SISTEMLERI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "EXCALIBUR G900"),
+			DMI_MATCH(DMI_BOARD_NAME, "NLCC 001"),
+		},
+	},
 	{}
 };
 
-- 
2.53.0



