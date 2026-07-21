Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BB82E736D;
	Tue, 21 Jul 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654642; cv=none; b=DnV/wY8mAurJiGy80HKTglTtPysQiifderCj1fSqm6arBcVTCgmeW0ataNZNLXmnmT+fMsKp0FZ6NzmAP0dQlKF0KajAmatjycE85L4eUNuuXhpgHuHSf49zP1YppjUJf3vXPMH3Sacp3LkAKV5Y+3kyGlZ71l2aRmA4DyZeoYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654642; c=relaxed/simple;
	bh=I5IPrMF+yW+xoVoO7CjlxEnvaJeMBa9Tc967eBmewgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaN1H38IJbG84Rck05U6ZvCzmpjXmQpaqtvjrUIF3D+ZX4+cbMr37LZrsb93YcIYPcIZsBKzgcyCqzQPYuDFJ8AxKov+unBnetZUsTWM7nqlqeMhfE5UxXjHsXrx82qHQbKjtMM5kJMHm2jySalYXMWem9kiAnJ7kZ2zkE898l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdmBvW5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdmBvW5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31501F000E9;
	Tue, 21 Jul 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654641;
	bh=6n11YX7DEI4RriDcpHhcWu4FoRVuh2GgjbgnqRIgvdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdmBvW5zXZ6vfIHj0jlGvANajaNNBKzAJjLMjGHbzHO+m753UukbhfuvqoI9j0Zrn
	 EW8Tk5H27C1ovM4+jgTwHSdIoqmbVDvWCe+P0NuYmHqqwGw5MgEuXmRddGiRAV7QC0
	 sX6SqPmvCdaPPlQML8QsRWGysIB2H6cXZGqV/nXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alberto=20Esca=C3=B1o?= <alberto_e_88@yahoo.es>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.1 1781/2077] platform/x86: hp-wmi: Add support for Omen 16-ap0xxx (8D26)
Date: Tue, 21 Jul 2026 17:24:14 +0200
Message-ID: <20260721152634.755290878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

commit 0aab31d47c2e857ca05028d718d1e0d239e683ad upstream.

The HP Omen 16-ap0xxx (board ID: 8D26) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile.

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_legacy_thermal_params.

Testing on board 8D26 confirmed that platform profile is registered
successfully and fan RPMs are readable and controllable.

Tested-by: Alberto Escaño <alberto_e_88@yahoo.es>
Reported-by: Alberto Escaño <alberto_e_88@yahoo.es>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221514
Cc: stable@vger.kernel.org # v6.18+
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260525102226.56300-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -250,6 +250,10 @@ static const struct dmi_system_id victus
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
 	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8D26") },
+		.driver_data = (void *)&omen_v1_legacy_thermal_params,
+	},
+	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8D41") },
 		.driver_data = (void *)&omen_v1_no_ec_thermal_params,
 	},


