Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3019A30AD06;
	Wed,  3 Dec 2025 15:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776473; cv=none; b=ZmPbme6EglypQCW91siH93Jb+9vlS4QN+xpnPI5MD7N16W8sX0ys7Bs+GAPa1CzaH6NIx7GkHDlqjRiG3zPkmivGPF0gBX77yFE/8OKI78ufj9x0ul6i1e2rR7r/JyEfo9X0vtB6DN5/YqiqXQqA1JF8Nqh4slck4vXi/Jy3DQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776473; c=relaxed/simple;
	bh=NZ4KlAyTvvfuf5t1BFP/sLhnGrBKdg22bQBLFAC85R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+WNjW7gK2dfVEmBsJgEmdyXN62G741L6mya4Qp/dOwie8Tb3iOT9reU/FzBp8HZKFkizTm2K71tFrBzttr5diUyM1dD9hqP6KctYXwru3TIT5B5CLmMnodR8fJl+vU2snPifyzXqnAWcXbrsPjb8l7v1Asegs51wd1nkVhS/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6lC2rS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6lC2rS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA69C4CEF5;
	Wed,  3 Dec 2025 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776473;
	bh=NZ4KlAyTvvfuf5t1BFP/sLhnGrBKdg22bQBLFAC85R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6lC2rS9SJBngobhhk6c0W7Bb3CJAK8OTBGeNllCwomAWSddbTmMaD5jhDaqacINr
	 +HH8M08flYPpnV27XMYDKvbO3edi7iU+dCHBf+2EmNhKAOieRk/EEA5vAmVJaqJcTA
	 XsvnJyVZ681tejAlQBUNMmiaf7oIDefyssocvm6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/300] Bluetooth: L2CAP: export l2cap_chan_hold for modules
Date: Wed,  3 Dec 2025 16:26:37 +0100
Message-ID: <20251203152407.775623218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e060088db0bdf7932e0e3c2d24b7371c4c5b867c ]

l2cap_chan_put() is exported, so export also l2cap_chan_hold() for
modules.

l2cap_chan_hold() has use case in net/bluetooth/6lowpan.c

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index b6345996fc022..166623372d0f5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -518,6 +518,7 @@ void l2cap_chan_hold(struct l2cap_chan *c)
 
 	kref_get(&c->kref);
 }
+EXPORT_SYMBOL_GPL(l2cap_chan_hold);
 
 struct l2cap_chan *l2cap_chan_hold_unless_zero(struct l2cap_chan *c)
 {
-- 
2.51.0



