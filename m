Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0954204E;
	Sun,  7 Jun 2026 10:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827037; cv=none; b=RUpiX18nFRFN2J5vspEcR4w6/p+nazAqKIc0PuaCRmtTyGzVHOFcKvgxSKGep9nfDz3Kl2CWOv0AP+OtN+aFiy1lQEE8dJI6CT9TeH4u5ncGFR8mrzWVYKwtu/R2cGibds5whO5xALCM4dilTY61t+1ylbrXMo/APCvonNwVZCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827037; c=relaxed/simple;
	bh=pl8DnaH0yRn0a2w8E0qxHRV8Hce6l6+h3G2ALuO3nO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My8UD4jB03K82hpnA6cGkqrIGxl3X8Lg00O4RFJt7POnSrjBLdLlct1yMoXstwrhGh8DFNSxfkTI3aY34e4N4ObvZ6MVE6WQ1sXt5iduY/6eIwkFbO58ohPynRZyLWaVeSzpmXyeXK1AVWvLR8lg5nUf1Bx5yNbpESKyWpS1hLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WDP5B+el; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDP5B+el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD21F00893;
	Sun,  7 Jun 2026 10:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827036;
	bh=J+JHHB7FbLehxgLkSPn1S1/cdEf/5IBh90+3P8IzhS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDP5B+el0UigavCq5hWeXnfER2DpJ4a7PVAUSCxXFCXDod1drEp5+gtVfnyoBXIGK
	 BrjT4H0e2I09AInwOraXGM9+Y0HyAQ1pnZ9zsyZbrPozFCi/vsaRDF5FVM/XMmAUca
	 Qkqur1wWarbDkt8ZUk0niCCQFl1+dpeEGJv/ghlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Marc Harvey <marcharvey@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/315] net: team: Remove unused team_mode_op, port_enabled
Date: Sun,  7 Jun 2026 11:57:01 +0200
Message-ID: <20260607095728.780089408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Harvey <marcharvey@google.com>

[ Upstream commit 014f249121d73909528df320818fba7693d0ec92 ]

This team_mode_op wasn't used by any of the team modes, so remove it.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Marc Harvey <marcharvey@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260409-teaming-driver-internal-v7-2-f47e7589685d@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 25fe708bbc59 ("net: team: fix NULL pointer dereference in team_xmit during mode change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 2 --
 include/linux/if_team.h      | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index a98f5e5061544c..712d8043e66e17 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -945,8 +945,6 @@ static void team_port_enable(struct team *team,
 			   team_port_index_hash(team, port->index));
 	team_adjust_ops(team);
 	team_queue_override_port_add(team, port);
-	if (team->ops.port_enabled)
-		team->ops.port_enabled(team, port);
 	team_notify_peers(team);
 	team_mcast_rejoin(team);
 	team_lower_state_changed(port);
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index ce97d891cf720f..0d550d44a1c230 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -121,7 +121,6 @@ struct team_mode_ops {
 	int (*port_enter)(struct team *team, struct team_port *port);
 	void (*port_leave)(struct team *team, struct team_port *port);
 	void (*port_change_dev_addr)(struct team *team, struct team_port *port);
-	void (*port_enabled)(struct team *team, struct team_port *port);
 	void (*port_disabled)(struct team *team, struct team_port *port);
 };
 
-- 
2.53.0



