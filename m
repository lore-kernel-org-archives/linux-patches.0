Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8924C97;
	Tue, 11 Nov 2025 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822449; cv=none; b=J08YWUnfdiXhSSSx+oc3JDmKmqGm/cXDob/sJUP9bsFrp3Sl6viu4QShBX/t8qy3nyVFa3A4NmNICsfajrpgWYZDv5syDSCp3mh4h4GA2Vv4xrHcdcXgmeCcyft5eJQpFdtoI9Uku0PG/cHjpXLrg42q11FQPsDNZOT6B8qedEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822449; c=relaxed/simple;
	bh=69nsx3wyqR6hQsbdBmmAFopHofkmRiF2XaK5IxjBnPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYFfhA0LHzKb3VZOh80I5GpyRhuSsJCF/K1jBTEs8jNoyu4LYf7PqfxeTX/uBYHmOXqGA2pZQbq0l/UAh0iHIAm+4kNqlaufgqeAw66W67Cpa4PTCD+Bd7VRjyjSqGK4HFLAPik4HkniIDKVzebUL+E40kgjxzkoYJ0yls3p1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlIUlN09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlIUlN09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE33FC19421;
	Tue, 11 Nov 2025 00:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822449;
	bh=69nsx3wyqR6hQsbdBmmAFopHofkmRiF2XaK5IxjBnPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlIUlN09YEyohNZlVz2mXLR+up+pK3sgbRiUrtVFi+XkDMx0Og4o3Zz6VToW0DdRZ
	 a5YGi0ggHXyBybFC+Tx5eFW8dfwS8hM8cH9fTBOvXJVhpW5RpoCUuvRClxkc71aMqP
	 Po114HbYsUb3mkKqKCruD0dEaYPGCCBxFbVsvZYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/565] dpll: spec: add missing module-name and clock-id to pin-get reply
Date: Tue, 11 Nov 2025 09:38:28 +0900
Message-ID: <20251111004528.083598856@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 520ad9e96937e825a117e9f00dd35a3e199d67b5 ]

The dpll.yaml spec incorrectly omitted module-name and clock-id from the
pin-get operation reply specification, even though the kernel DPLL
implementation has always included these attributes in pin-get responses
since the initial implementation.

This spec inconsistency caused issues with the C YNL code generator.
The generated dpll_pin_get_rsp structure was missing these fields.

Fix the spec by adding module-name and clock-id to the pin-attrs reply
specification to match the actual kernel behavior.

Fixes: 3badff3a25d8 ("dpll: spec: Add Netlink spec in YAML")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20251024185512.363376-1-poros@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/dpll.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
index f2894ca35de84..860350e61edb5 100644
--- a/Documentation/netlink/specs/dpll.yaml
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -517,6 +517,8 @@ operations:
         reply: &pin-attrs
           attributes:
             - id
+            - module-name
+            - clock-id
             - board-label
             - panel-label
             - package-label
-- 
2.51.0



