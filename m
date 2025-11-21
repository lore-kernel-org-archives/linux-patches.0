Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675CE34F476;
	Fri, 21 Nov 2025 13:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732978; cv=none; b=dJa4Zcs5gzWI0JbsrsOgn7+OjrNa6rtCeidf28cC3DNuNCqr0mZo8r8WgW+LRJ/brga+WrOppgBAgR90z09yEQolO+sKTLRvCrIvn1v1jYym6jAu4DrmBatFqhvqnJnSLY24nOoBAfZDf4yIeg+GlnXfs7LgdkcEjYA38vhz08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732978; c=relaxed/simple;
	bh=uo8eLAYoASi0V0X/FKH0b5yUFeDm7XEIqJfqet+zEHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tu1FiwTFhglfTAb2SckM9YXDM0MpWoWO+dcA9XAHaVRI/zIgU95JJ0psGeN4tOtjdPgIFComRwrJqwIhaTMplvjSL/Yw1kVdtD3lR/SEBeHzwQIRE39K8qGhLdMMkDCL1QPCPbWkON/+5QzHEHTx6kT+2W2p3rMaw4r0hOyyDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dlSFTfmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlSFTfmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13C4C4CEF1;
	Fri, 21 Nov 2025 13:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732978;
	bh=uo8eLAYoASi0V0X/FKH0b5yUFeDm7XEIqJfqet+zEHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlSFTfmxoHRxAsxtxJvPMx6Zb0eR83Gr95+Ausd+WZLxjmOZ9KBRAFLTQvIO5gng4
	 B+5qsPPETseI6qXYIrTH3RywBeHhw3lfg85KcwkCgydNr6Qz7xG/VRApj7j7jCgfpL
	 lJxc4tjWaJhKHEgtk9i/CSldWwFr79fUEhGqOD5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/529] um: Fix help message for ssl-non-raw
Date: Fri, 21 Nov 2025 14:10:06 +0100
Message-ID: <20251121130241.947220684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 725e9d81868fcedaeef775948e699955b01631ae ]

Add the missing option name in the help message. Additionally,
switch to __uml_help(), because this is a global option rather
than a per-channel option.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ssl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 277cea3d30eb5..8006a5bd578c2 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -199,4 +199,7 @@ static int ssl_non_raw_setup(char *str)
 	return 1;
 }
 __setup("ssl-non-raw", ssl_non_raw_setup);
-__channel_help(ssl_non_raw_setup, "set serial lines to non-raw mode");
+__uml_help(ssl_non_raw_setup,
+"ssl-non-raw\n"
+"    Set serial lines to non-raw mode.\n\n"
+);
-- 
2.51.0



