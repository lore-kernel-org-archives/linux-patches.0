Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968291DE2AE;
	Tue,  8 Oct 2024 12:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390160; cv=none; b=brBm5KMb4inxE8OkL+9ac2PfPEWmOEEmtNYQpGnlMCbnKiQRT1trfvn35zvNzEKXTTX9u6iehpdErQeyQXvJsCefJx5VrJuFRDEV80C2hepgqFifjznV8v7NTuTj7Fqh2h1DGuoRbKqS3F3D3pdTYWIOw8InVwICOs6Tk3ScBbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390160; c=relaxed/simple;
	bh=MmJaeCKN3AYDM/J7+BgW4kxAbBHsBQoWhOIaqhpCyEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSLoD9kjTjexJ0u9zNrQop7NL4tAOhhDyZfDGcWPuGzctEzuo/FzwSGRgZoiNAFxQsS626es8mjq2TJyN97BWdksqyxAguSLDAzzzgqvEMaygytlIawKbJB1OSLcuFJHua/d9+PmaMtTfm722RTV2Oh1xGXlCc8B52ZSVZhyxdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMSwLYbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMSwLYbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0EFC4CEC7;
	Tue,  8 Oct 2024 12:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390160;
	bh=MmJaeCKN3AYDM/J7+BgW4kxAbBHsBQoWhOIaqhpCyEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMSwLYbO+gZHqQu63GGgILAqtBJWH2FTl3Pk3tbpVbsRJ/H+Bu82AQDDPqF5IAeRE
	 VJjYQJbbGKB7U6qvBBRRod+sfNTlYnzR12Y4EOa2tR5rNFqX2haVXDM/FVrFnfXa45
	 VPJkDoUu6cmZbqqHL5IvDJQYyQIzTWoqj4Leivag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	aln8 <aln8un@gmail.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 208/482] platform/x86/amd: pmf: Add quirk for TUF Gaming A14
Date: Tue,  8 Oct 2024 14:04:31 +0200
Message-ID: <20241008115656.496309398@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: aln8 <aln8un@gmail.com>

[ Upstream commit 06369503d644068abd9e90918c6611274d94c126 ]

The ASUS TUF Gaming A14 has the same issue as the ROG Zephyrus G14
where it advertises SPS support but doesn't use it.

Signed-off-by: aln8 <aln8un@gmail.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240912073601.65656-1-aln8un@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/pmf-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/pmf-quirks.c b/drivers/platform/x86/amd/pmf/pmf-quirks.c
index 48870ca52b413..7cde5733b9cac 100644
--- a/drivers/platform/x86/amd/pmf/pmf-quirks.c
+++ b/drivers/platform/x86/amd/pmf/pmf-quirks.c
@@ -37,6 +37,14 @@ static const struct dmi_system_id fwbug_list[] = {
 		},
 		.driver_data = &quirk_no_sps_bug,
 	},
+	{
+		.ident = "ASUS TUF Gaming A14",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FA401W"),
+		},
+		.driver_data = &quirk_no_sps_bug,
+	},
 	{}
 };
 
-- 
2.43.0



