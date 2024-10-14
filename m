Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5497019E802;
	Mon, 14 Oct 2024 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916108; cv=none; b=JnHx2IoAgSmaKz+C2V+en10srLfnbMm4Lj95wApZJg/ikUP4WrTzartGpLiIV+go76VnjJnORYpIFH8MxbwQqbU1odysd2mmAgUZsCt3rbzArmS9epWP0QpEIa9y/bs2m04v1uZP4CKdnTh5ODyQk6kRrzS0qPPo2fRPEOAtwNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916108; c=relaxed/simple;
	bh=Y3IjOLey9ZMVS9WZq49dbkWFuMVZ4EpE+sDvzG2a1qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVlbtQAUFmAXHGf6yF+8DQ3C9XBaXDI2UsrEDP1RnyCuV+/e6/nbaeocsiGZ+0aOxuN90u1FzR+gtRRXVumOE+sT/F70F3q2SkIi1USY94tNhBPn6bBOh6UNlLEzGj4vM5065wgSZW3vp46yC773ypL7BH8270O4DLcviNSLN/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PtogZuvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PtogZuvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83FCC4CEC3;
	Mon, 14 Oct 2024 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916108;
	bh=Y3IjOLey9ZMVS9WZq49dbkWFuMVZ4EpE+sDvzG2a1qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtogZuvWjGLM+KF8E7C3zkVjrxAQE+b+ODrso1acAhYcbqMeBUuacZHmyC68Q4MNf
	 N3jjUGVqOuem507qCbbN3BiE5OLmED46OsIYHcSKVOYgwJuhtz8I9X1NrC7yWFlJrB
	 ghJvz7XGYAXr0FnwSXCAnVVOvrCumAnXw+XrGpEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.11 086/214] ice: disallow DPLL_PIN_STATE_SELECTABLE for dpll output pins
Date: Mon, 14 Oct 2024 16:19:09 +0200
Message-ID: <20241014141048.347790911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit afe6e30e7701979f536f8fbf6fdef7212441f61a ]

Currently the user may request DPLL_PIN_STATE_SELECTABLE for an output
pin, and this would actually set the DISCONNECTED state instead.

It doesn't make any sense. SELECTABLE is valid only in case of input pins
(on AUTOMATIC type dpll), where dpll itself would select best valid input.
For the output pin only CONNECTED/DISCONNECTED are expected.

Fixes: d7999f5ea64b ("ice: implement dpll interface to control cgu")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_dpll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_dpll.c b/drivers/net/ethernet/intel/ice/ice_dpll.c
index e92be6f130a3d..3d20c3b232aa9 100644
--- a/drivers/net/ethernet/intel/ice/ice_dpll.c
+++ b/drivers/net/ethernet/intel/ice/ice_dpll.c
@@ -651,6 +651,8 @@ ice_dpll_output_state_set(const struct dpll_pin *pin, void *pin_priv,
 	struct ice_dpll_pin *p = pin_priv;
 	struct ice_dpll *d = dpll_priv;
 
+	if (state == DPLL_PIN_STATE_SELECTABLE)
+		return -EINVAL;
 	if (!enable && p->state[d->dpll_idx] == DPLL_PIN_STATE_DISCONNECTED)
 		return 0;
 
-- 
2.43.0



