Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023237;
	b=A0ov6HP68Ihy48G5Mj9mWw0weLTlph6cyFXMo7x+nfK00zA1F6W1dooS0LOxyC/hp+tn
	 2k9z4GHxa/HhTel4DBbobt3fsFR1VsXi3dBwy/MJiApFkAdiOs1N0SPSd+WiMHlohXUQh
	 4M0Lu4s9yv0BGjgE6iWtVAvZWr9yAE9KxF4J+vNJmAehcX04iwA/xOSTFD5hWmkFs2SH8
	 bg96pW9z2etDgMUB1NkJmzcrZl8r/ib20kQYywNcg2aCNz5YqANA9jES42q0OKIpI9LDG
	 rAsHUgs9GL80NzTd44I9D6iE0aomOjOkcn20ivXAJhJrAmbI0FwNQLKwpuXK80q+B5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MhL7hOt3KbP8jqXZnDvAZgTpfBDFAMc3EHfyr08DYlk=;
	b=NiSMwQmppUTkeOayHjBJ469kg/ff/fjR+vG+kzizdt3CM/gf8wC3nhgEDWWpdJY2yw5K
	 YjmXkAYF/axpPzmsrxcaRz707Nm8MwCJ/jTgcXZFJ12kzueH9rmql7Mdl+QRS40LD4fmc
	 UJ8EHr4F5p2WvfCJQmUnjZ8m4Q5dM0ee8SrbdjmUy7yHG3AxKcx1jr2bNPJIG/cZVoa24
	 akZysNqZvI4MW8sROXBKxeoB0bqdL03GAgsTlTWxTKpAb+ApLgELi/C1K5srA0GRUMau6
	 WQhea7RPqLBb/af3db4lk9maQSg3dry/ZP/Wa6AJE2wJo8gLD/takS93XAsRUtyOu/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcCo2Z0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA36606A33B;
	Wed, 18 Nov 2026 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vcCo2Z0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7666A1F000C4;
	Wed, 18 Nov 2026 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023237;
	bh=MhL7hOt3KbP8jqXZnDvAZgTpfBDFAMc3EHfyr08DYlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcCo2Z0UXz2Hj1IbgoN448TjqvcxkXUI58MaO9BZ0W2s7xHvP/maf4ui7UielQU/L
	 L1TTy12bS8XsASo/r/OCBXif/kRCwHgGsgREbtSWA8B2ktybvpJqgaoJ5o6I2E8HX9
	 Yi49TLZu2e/fcto2Ko7idRxRAOJeLgsVR7pwO2VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0248/2151] ACPI: extlog: Trace CPER Non-standard Section Body
Date: Wed, 18 Nov 2026 15:33:03 +0100
Message-ID: <20261118150130.828816338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>

[ Upstream commit a2995f7dab51bc0cfabd750f9848a5ee7612099d ]

ghes_do_proc() has a catch-all for unknown or unhandled CPER formats
(UEFI v2.11 Appendix N 2.3), extlog_print() does not. This gap was
noticed by a RAS test that injected CXL protocol errors which were
notified to extlog_print() via the IOMCA (I/O Machine Check
Architecture) mechanism. Bring parity to the extlog_print() path by
including a similar log_non_standard_event().

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
Link: https://patch.msgid.link/20260114101543.85926-2-fabio.m.de.francesco@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 8bf58815315a ("ACPI: APEI: GHES: Validate CXL protocol error section length before RAS cap copy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index d4f21b9b798a3..542e8b96a86ae 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -192,6 +192,12 @@ static int extlog_print(struct notifier_block *nb, unsigned long val,
 			if (gdata->error_data_length >= sizeof(*mem))
 				trace_extlog_mem_event(mem, err_seq, fru_id, fru_text,
 						       (u8)gdata->error_severity);
+		} else {
+			void *err = acpi_hest_get_payload(gdata);
+
+			log_non_standard_event(sec_type, fru_id, fru_text,
+					       gdata->error_severity, err,
+					       gdata->error_data_length);
 		}
 	}
 
-- 
2.53.0



