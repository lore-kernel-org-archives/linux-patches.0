Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034562;
	b=e1rNOUXTeB/A8APss54VD1X5ZTnzcbdnWcGTKUD9VkEUze5UcwPlExJ32ZDbeZ45oqhN
	 Zq1k4/vOJj6weDHmRq3j/N8Vl4zZlIBHpnury7FkOMdewCNaExzf4w3B1ZpvB5aph3xVY
	 5at0pnJH3ZW1rNns155jQbdtpFmN2S+I18ZpUpjuuxd+e3LsEzNLabRKFi/GPp3xXvWsZ
	 vfKSkzzCxJpE+ec/k3M8Zi8mlHNaOOWFfPBC7frn/hQzywzJO5WE6zpFJ/xsYwU1Uk/Jc
	 QDxr7t0yGbOuPR6hXSRhsHMOMSETTcXES7lCF5ZMzJZR4b1W7IRcJ8BA/ylenQ6CYsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SfAfX+FvtRAZM2YU2JxlZjxQvswatRaP2Pqn4U26p3w=;
	b=zzlvs67BOQOypLxTW7OYCeFsM0ZHu4AyjjO2X/QrbxkFpeL8YZr75Heot5bxvpzFB2bP
	 LJ5j1wLMv+w9Lp1+RwO4Vxin800+RChfWT76sExrn+SoV+fmD30mi1tfqypF3YZKCBhrG
	 AxURRhzZZbeQfBY/+qPvgCGf8N9zVX5bFJ+DDsmo6/+7SwfdPNp040RfA2PmuciVAerz+
	 UTOSHDqgdwn0yh7Xgl7EEqInmfpWKhM8VNSAQkVtu4OOwdx33aL0nV3xIXFyYd9ZvAd2/
	 9oip0lt2aM7KFZguu9oQCE77TtniPSot/qs+lGvxrPK7NdLnnbqPTQwUqlInRDQJ+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOJrBlzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F11C606A320;
	Wed, 18 Nov 2026 20:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lOJrBlzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09981F000C4;
	Wed, 18 Nov 2026 20:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034562;
	bh=SfAfX+FvtRAZM2YU2JxlZjxQvswatRaP2Pqn4U26p3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lOJrBlzoiHc6CeU352BRxckFH335cswS2NO67n6RQ+tu9AiG3nET31ILT15knh9ss
	 grBT2o0izPRt3MHly+Rg5L6mSRBsTrc1MW5RSeH3L4hHaMH5v+qBJdD5QlI67KT+7Z
	 mS8mCwZTRcDDSw+BHRq5njk5OhuLMMTJ3BMFY8LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0413/3318] platform/x86/intel/tpmi: Move TPMI ID definition
Date: Wed, 18 Nov 2026 15:17:15 +0100
Message-ID: <20261118150328.888733324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 046d7be6210e7f870e53eb38fd410237e9d1d88f ]

Move TPMI ID definitions to common include file. In this way other
feature drivers don't have to redefine.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231204221740.3645130-4-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 574b59bb4b6b ("platform/x86: ISST: Validate parameter for frequency and priority")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/tpmi.c | 13 -------------
 include/linux/intel_tpmi.h        | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/intel/tpmi.c b/drivers/platform/x86/intel/tpmi.c
index 4c42c28bdd3d4..021e56f52ac12 100644
--- a/drivers/platform/x86/intel/tpmi.c
+++ b/drivers/platform/x86/intel/tpmi.c
@@ -143,19 +143,6 @@ struct tpmi_info_header {
 	u64 lock:1;
 } __packed;
 
-/*
- * List of supported TMPI IDs.
- * Some TMPI IDs are not used by Linux, so the numbers are not consecutive.
- */
-enum intel_tpmi_id {
-	TPMI_ID_RAPL = 0, /* Running Average Power Limit */
-	TPMI_ID_PEM = 1, /* Power and Perf excursion Monitor */
-	TPMI_ID_UNCORE = 2, /* Uncore Frequency Scaling */
-	TPMI_ID_SST = 5, /* Speed Select Technology */
-	TPMI_CONTROL_ID = 0x80, /* Special ID for getting feature status */
-	TPMI_INFO_ID = 0x81, /* Special ID for PCI BDF and Package ID information */
-};
-
 /*
  * The size from hardware is in u32 units. This size is from a trusted hardware,
  * but better to verify for pre silicon platforms. Set size to 0, when invalid.
diff --git a/include/linux/intel_tpmi.h b/include/linux/intel_tpmi.h
index ee07393445f9f..fdcebb8c30e98 100644
--- a/include/linux/intel_tpmi.h
+++ b/include/linux/intel_tpmi.h
@@ -12,6 +12,19 @@
 #define TPMI_MINOR_VERSION(val)	FIELD_GET(GENMASK(4, 0), val)
 #define TPMI_MAJOR_VERSION(val)	FIELD_GET(GENMASK(7, 5), val)
 
+/*
+ * List of supported TMPI IDs.
+ * Some TMPI IDs are not used by Linux, so the numbers are not consecutive.
+ */
+enum intel_tpmi_id {
+	TPMI_ID_RAPL = 0,	/* Running Average Power Limit */
+	TPMI_ID_PEM = 1,	/* Power and Perf excursion Monitor */
+	TPMI_ID_UNCORE = 2,	/* Uncore Frequency Scaling */
+	TPMI_ID_SST = 5,	/* Speed Select Technology */
+	TPMI_CONTROL_ID = 0x80,	/* Special ID for getting feature status */
+	TPMI_INFO_ID = 0x81,	/* Special ID for PCI BDF and Package ID information */
+};
+
 /**
  * struct intel_tpmi_plat_info - Platform information for a TPMI device instance
  * @package_id:	CPU Package id
-- 
2.53.0



