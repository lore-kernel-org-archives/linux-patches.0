Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E51779BD;
	Fri, 27 Sep 2024 12:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439972; cv=none; b=ihW0p9/I3PxDnQPL0v8y7wbAM+9/DCtz5HzXCy2aVPqYmszThW3+ntLZYMXTYH/mWr57jcQmuvLSkK/gr9WOrDW5UpZ8G6Lax059seJ+ZAG2nKLoeR53RK1LsqooD+f61lO76/Rjx5VmpFDoOZoLxY4pA1wgYGSVX3qFHsbTW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439972; c=relaxed/simple;
	bh=3NVQBYcb2hjHHrLUTMCEJDKOiIXCNARVAq0flGbR16Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isRp3VLhBao+6uqFzUYEZbGGmFkSPGH1iye38cxBaUZnosk3zBcsQ17arknBGgZ/VD6f24uBQy2k2aFgXXTxwTjkEWFt3icZXSixA6b+IqJ1M7O4Pk0DIQXCfUmkTN5tWnEyibxnGC1kRZ/0jyKEqUa4VPh+3QKsr4plEPdCG58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vbzcJxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vbzcJxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4650DC4CEC4;
	Fri, 27 Sep 2024 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439972;
	bh=3NVQBYcb2hjHHrLUTMCEJDKOiIXCNARVAq0flGbR16Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vbzcJxPZeRFM9ocduwV41Jb7o9GJxH97VeA9nmQcnyz1TWXTP00+Z+zvdMYFGL2j
	 3joUd0xHVrxQ64T0xrvvO2ijdArg+6y6RXLEyeOFteUqVhUSDV+B73Zq1lACe+g/CZ
	 OczVO8DjzvyOQrKQx4t6pXNeZxRgV1QL9OmcJJ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 42/54] powercap/intel_rapl: Add support for AMD family 1Ah
Date: Fri, 27 Sep 2024 14:23:34 +0200
Message-ID: <20240927121721.506656152@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>

[ Upstream commit 166df51097a258a14fe9e946e2157f3b75eeb3c2 ]

AMD Family 1Ah's RAPL MSRs are identical to Family 19h's,
extend Family 19h's support to Family 1Ah.

Signed-off-by: Dhananjay Ugwekar <Dhananjay.Ugwekar@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20240719101234.50827-1-Dhananjay.Ugwekar@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 9d3e102f1a76b..3dfe45ac300aa 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1280,6 +1280,7 @@ static const struct x86_cpu_id rapl_ids[] __initconst = {
 
 	X86_MATCH_VENDOR_FAM(AMD, 0x17, &rapl_defaults_amd),
 	X86_MATCH_VENDOR_FAM(AMD, 0x19, &rapl_defaults_amd),
+	X86_MATCH_VENDOR_FAM(AMD, 0x1A, &rapl_defaults_amd),
 	X86_MATCH_VENDOR_FAM(HYGON, 0x18, &rapl_defaults_amd),
 	{}
 };
-- 
2.43.0



