Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51A626461E;
	Tue,  8 Apr 2025 12:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115832; cv=none; b=moypGCUb2u/bZcg32L3gZ1mYtnjQZWQMENEEE7Ofc50Fm76AeMz+A6DjOL9u5bYeA/rb1LGQv5YH5o05lZJoUF33jb7zCqSevgglCDAEBVJoCunCAW5C45b3wjFRLxNgoBmcwTfYZxDj8Ys4RvIM6SmlLI/t7b8559XePv7Q2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115832; c=relaxed/simple;
	bh=YrD3qbEMaUtGXYo7p0W0nYIcUS2szkeez08+leVlECw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWzlRO+PWg5jjTLKGB1EyiLeHKaVoTSFW2CDfLiM8CqBn8ZWgtqwnrnZqEakmQ9LiHAj9h7DusDP50b3kLkmfjx9RaecJd71AaTKHlXD8YE2EKq70+asud9o+XHH6li+X3AhnZhwyk2v+AM1SDeCSrkwYxy6dmVVwKGqVFw1csA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJ0w+3Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJ0w+3Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C58C4CEE5;
	Tue,  8 Apr 2025 12:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115832;
	bh=YrD3qbEMaUtGXYo7p0W0nYIcUS2szkeez08+leVlECw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJ0w+3BtcVrNYjUednJo+v3fp026firXRKUeHCIh94P7iMWJHSKAkfZVA25Zks8uG
	 32q8Ylil9dxBsfL9V7/6nxXj69tiXVSA2dNNKX86g+gl1ewwzveITYjn/Cugea22aB
	 1rYEZsBp7VydTgT7SeApkI7bvGmJNKdxJPWkHv28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/204] pinctrl: renesas: rzv2m: Fix missing of_node_put() call
Date: Tue,  8 Apr 2025 12:50:11 +0200
Message-ID: <20250408104822.735621549@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 5a550b00704d3a2cd9d766a9427b0f8166da37df ]

of_parse_phandle_with_fixed_args() requires its caller to
call into of_node_put() on the node pointer from the output
structure, but such a call is currently missing.

Call into of_node_put() to rectify that.

Fixes: 92a9b8252576 ("pinctrl: renesas: Add RZ/V2M pin and gpio controller driver")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250305163753.34913-4-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzv2m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzv2m.c b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
index 2858800288bb7..dc4299c03b990 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzv2m.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzv2m.c
@@ -943,6 +943,8 @@ static int rzv2m_gpio_register(struct rzv2m_pinctrl *pctrl)
 		return ret;
 	}
 
+	of_node_put(of_args.np);
+
 	if (of_args.args[0] != 0 || of_args.args[1] != 0 ||
 	    of_args.args[2] != pctrl->data->n_port_pins) {
 		dev_err(pctrl->dev, "gpio-ranges does not match selected SOC\n");
-- 
2.39.5



