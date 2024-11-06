Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A06D1E1C38;
	Wed,  6 Nov 2024 12:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896495; cv=none; b=E9LLERbIPoWcJjn8pMAG688iSt5QcddjuDa8XqW/EhE0m1kWs0EUtctv/uT5jIXUVgllrTjb2oa/YW4q3aydX1GDcr+biDi2n7iazQspKO4eoIQA28d8CbE2+5ZorMmPS3bc4Atq1iytyhIfB5pJQAo/fpdSAo8e/kA5FwA9NyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896495; c=relaxed/simple;
	bh=2YKgCrolF694gS/++uu+pY3cuhE28nf+YMHW/+h7ABE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4DKeXCpVnQaKnT88RyGFbN0RrLSnCu/ARlSngPVwQix5HuGOsJK2yVkArwafWAiiRZX5Q78nR3Q16aja34kXI55v0hmjKfM12T8aqbrLRUzqAPVP9E4FrVqj6G8UKfF37XRgx+trcx/EqTQtd/Zvmrp4wfknCbFFClIJi5IYj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxOwAMVn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxOwAMVn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24FAC4CED4;
	Wed,  6 Nov 2024 12:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896495;
	bh=2YKgCrolF694gS/++uu+pY3cuhE28nf+YMHW/+h7ABE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxOwAMVnszuHzJVDNgVvUTEHWB1U30TSG5+6VJMlOp7reTAgvVtX7UJ8pqWEoc/tX
	 xq4HHFFWrgiYboi30ctPiTPGN+2p6pESTe9fljoqkqZUV/HJntcW5/T+01/4e5wVGu
	 9Je9Psh0qAD0kQ4hu8CK1RhRBOsP/vcLeMxK8edU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 221/245] drm/i915: Skip programming FIA link enable bits for MTL+
Date: Wed,  6 Nov 2024 13:04:34 +0100
Message-ID: <20241106120324.697082018@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Sousa <gustavo.sousa@intel.com>

commit 9fc97277eb2d17492de636b68cf7d2f5c4f15c1b upstream.

Starting with Xe_LPD+, although FIA is still used to readout Type-C pin
assignment, part of Type-C support is moved to PICA and programming
PORT_TX_DFLEXDPMLE1(*) registers is not applicable anymore like it was
for previous display IPs (e.g. see BSpec 49190).

v2:
  - Mention Bspec 49190 as a reference of instructions for previous
    IPs. (Shekhar Chauhan)
  - s/Xe_LPDP/Xe_LPD+/ in the commit message. (Matt Roper)
  - Update commit message to be more accurate to the changes in the IP.
    (Imre Deak)

Bspec: 65750, 65448
Reviewed-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240625202652.315936-1-gustavo.sousa@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_tc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_tc.c
+++ b/drivers/gpu/drm/i915/display/intel_tc.c
@@ -393,6 +393,9 @@ void intel_tc_port_set_fia_lane_count(st
 	bool lane_reversal = dig_port->saved_port_bits & DDI_BUF_PORT_REVERSAL;
 	u32 val;
 
+	if (DISPLAY_VER(i915) >= 14)
+		return;
+
 	drm_WARN_ON(&i915->drm,
 		    lane_reversal && tc->mode != TC_PORT_LEGACY);
 


