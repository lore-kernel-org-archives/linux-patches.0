Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E921A6195;
	Tue, 30 Jul 2024 16:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358523; cv=none; b=cQyEX6Sgy4gc4bRotk3uBILLbNc7kgPZX0IrGNveUiOSDcRfKx7VRdBeu0XX4JNcRVxhppsHyhffW849aax+PV93JvMjmtjtqdEKNa5fHJEFv07DP7Kv/0Vae1ckYqP+FYw4BJhMeRiEsgZBlFzEief+qDBMKu4oDRwkoZyWZA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358523; c=relaxed/simple;
	bh=MeBAtBfcZVlxi1OXlll3Kp0zq0OKfaTGE3BH4U715dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0hE0b2te5+DOW7EqkJySXQDQSJXVO1H9/uss07ex2/FMd/aPgcHrTx6vufSn6ZhJNsxSXNkuV9Wiwy3M9nmBQk6Jm8Dbxl31pW8PslCl7Tswyw+MdN08L/Qfn95ISgFzIbxZpWXmwq7qgWIF/UE1Jykdpq8yo/AB15b07V/RCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJuE121v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJuE121v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B451C32782;
	Tue, 30 Jul 2024 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358522;
	bh=MeBAtBfcZVlxi1OXlll3Kp0zq0OKfaTGE3BH4U715dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJuE121vzeP12CMxVcIpAhIVeOLkmBqtUygd1GU45a1C8vi6DHc7LQ4jo0qiVqmKY
	 R+f3H6mJBSlCLWsmBOI79b9V7hqAydftbTNyxd0d2jUALBqt59NISrOlg+N3AK2zRL
	 rmte0ONaHeVPcqoV9BeJvPop9IIewYwfSWERPm6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 398/440] um: time-travel: fix time-travel-start option
Date: Tue, 30 Jul 2024 17:50:31 +0200
Message-ID: <20240730151631.347633424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7d0a8a490aa3a2a82de8826aaf1dfa38575cb77a ]

We need to have the = as part of the option so that the
value can be parsed properly. Also document that it must
be given in nanoseconds, not seconds.

Fixes: 065038706f77 ("um: Support time travel mode")
Link: https://patch.msgid.link/20240417102744.14b9a9d4eba0.Ib22e9136513126b2099d932650f55f193120cd97@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/time.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/time.c b/arch/um/kernel/time.c
index 3e270da6b6f67..c8c4ef94c753f 100644
--- a/arch/um/kernel/time.c
+++ b/arch/um/kernel/time.c
@@ -874,9 +874,9 @@ int setup_time_travel_start(char *str)
 	return 1;
 }
 
-__setup("time-travel-start", setup_time_travel_start);
+__setup("time-travel-start=", setup_time_travel_start);
 __uml_help(setup_time_travel_start,
-"time-travel-start=<seconds>\n"
+"time-travel-start=<nanoseconds>\n"
 "Configure the UML instance's wall clock to start at this value rather than\n"
 "the host's wall clock at the time of UML boot.\n");
 #endif
-- 
2.43.0



