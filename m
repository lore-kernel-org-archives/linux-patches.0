Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE3F2C188;
	Fri, 22 Dec 2023 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9T5pnQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B609BC433C8;
	Fri, 22 Dec 2023 18:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703269627;
	bh=1ogxdoJeOc5yB3uT5PUZ+U4hWTGXsTipIFLZZ4w0iVg=;
	h=From:Subject:Date:To:Cc:From;
	b=Q9T5pnQp/qMhoaiGRcMZ5eumBGWq5iAUp2PCwcE/5F6qRoCIaYM+toRDrSMcni76m
	 72n7NusZefZY38HAHTXRqT3/Zx5MwsDv7vLIEe6/VY/wZVkv86DwrsD9OnZZeqKYzn
	 dHpI9FO31otLmEIjHqN2u4AO9PqKhVWR+K9j/KBgl+Oh4aInSMJOs/VKQLiNIo7NsU
	 Jx8LpAhfybqQhW3eDZttvsx3IVFRxxJzh8dQzz1YW/CiZj3YiXuIIb4Foz93QWtbZS
	 r9sYVdNW0d9LcYmgsjLWOKBPL0zYiS4y3ddxzQ/8yIyhlDLyHSeUCc4063gpvz53OM
	 IQulNIvM+SBuA==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/2] platform/x86/intel/pmc: Fix recent instances of
 -Wmissing-prototypes
Date: Fri, 22 Dec 2023 11:27:00 -0700
Message-Id: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPTUhWUC/x3MwQqDMAwA0F+RnBewmRPZr4wdrKZdQNvSFHGI/
 27x+C7vAOUsrPBuDsi8iUoMFebRwPQbg2eUuRqopachIpRQeMG0TriKqgSPKccSyz+x4uDsqzW
 dNb0doBYps5P97j/f87wAuwQQZm4AAAA=
To: irenic.rajneesh@gmail.com, david.e.box@intel.com, hdegoede@redhat.com, 
 ilpo.jarvinen@linux.intel.com, rajvi.jingar@linux.intel.com
Cc: platform-driver-x86@vger.kernel.org, patches@lists.linux.dev, 
 Stephen Rothwell <sfr@canb.auug.org.au>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=925; i=nathan@kernel.org;
 h=from:subject:message-id; bh=1ogxdoJeOc5yB3uT5PUZ+U4hWTGXsTipIFLZZ4w0iVg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKmtV35tK1E35/2r/DNw0VuFvqojYg8zeRj+xCw/Ub6s+
 O7H4t2mHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi1oUM/5S9Z7xlW/T4olt9
 wozt5x5LWs5iDjSU15pw2lYp8fBpuzRGhm65oKcm1iZcV4qXrVC3mVnsx3jFjUHuK79yirO+s1Y
 eFwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

As reported by Stephen at [1], there are a few instances of
-Wmissing-prototypes, which break the build with CONFIG_WERROR=y. This
series marks these functions as static because they are not used outside
of these translation units.

Feel free to squash these into the original changes if the branch is not
set in stone.

[1]: https://lore.kernel.org/all/20231222135412.6bd796cc@canb.auug.org.au/

---
Nathan Chancellor (2):
      platform/x86/intel/pmc: Mark arl_d3_fixup() and arl_resume() as static
      platform/x86/intel/pmc: Mark lnl_d3_fixup() and lnl_resume() as static

 drivers/platform/x86/intel/pmc/arl.c | 4 ++--
 drivers/platform/x86/intel/pmc/lnl.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: 119652b855e6c96676406ee9a7f535f4db4e8eff
change-id: 20231222-intel-pmc-missing-prototypes-8fb5014b16b8

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

