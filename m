Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618454;
	b=dZeQxJGvSrfU4WnYfT0vSK7w6dsoyTfnEwy07B3xs2uHqxay1dfv5BOGq/uCcGTmF2h9
	 cQT14cjBzQ925guLyLHFh8f3LQpFhbPb+rpGX8ajrK/2Oe6YFO8dsd3WDHum5Pu0MS1Kp
	 LBQopfsjB2F94i5xFE9FV8DQ5N44jxSubD0FWWRJLy+WGPZKVU+6Vj+eP0ZG7wzkEBBOt
	 UEN+sYg90jogxkgm/lxOM1Yo5E3tHr+0Feif2pyeRaAiQBi/naoRe3XN+Gz2tJzsHEV6a
	 PvFJUPVV5pSYTJXo74u3/9PLsYKoPvNGNuNpHxQUsBUG58IvjqtCg1/HmxVqon6EjAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1aNXWXA55UFwm3OoHT6Wbf8ltuRaW6p8tK4pmMRwLfE=;
	b=eAPBV+dUnRKUYqpisPkUsJMrc5WO/KDQkyBZMg8NCIOEjkihju0TnYsEsWyvIFK1kLIW
	 tLzuG503KrlvdngVmLWuVsf75NPoiu3ywh05YWKeZWWgI2TvS9eQUXGcl9iyFSpoKjQzG
	 x3QZoleBT2F2oqSdmCDQhJ0Nv9+8mIDnCvp52UPrjBRcWPStrbjBgGEO0ZAQRmIjyHOt8
	 JfH/QWjbYX6Of/S4iIrzVa/qeK6rbW79qT2MdmcunTJ/6ZKrVxIfkm7Hx05n/BsabMbBO
	 WgwQZLv9XNa7f3ml4vhY1MmHP53sOkmrlWQ72a+pT6Ncaxc+YbOI9Pu6tiruL3REUsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HN8WN9f+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB3E606A31E;
	Wed, 25 Nov 2026 14:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HN8WN9f+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80D61F000C6;
	Wed, 25 Nov 2026 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618454;
	bh=1aNXWXA55UFwm3OoHT6Wbf8ltuRaW6p8tK4pmMRwLfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HN8WN9f+bozFOMrNwsXRio0nE388Pas7pUKtb9TXf5CkDdq+7pJHHC4+4jAF71+GY
	 FsPcjkrj6YA1xoNJi/COjvGMi+w/4WnF9eBLzY3MWc+ORQqMaTeqdLqwaw81K5hG4N
	 CO4p2+9i8RIbe0CaacxKankGFTp64Dwn1cqqaa7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0285/1005] PM: runtime: Clarify ->runtime_idle() callback return value handling
Date: Wed, 25 Nov 2026 15:27:03 +0100
Message-ID: <20261125143828.418756621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit aedc51762a0d3d4a50d1542b59aafcd6060c4b39 ]

This doc says "Negative error return codes are ignored by the PM core"
for ->runtime_idle(). This is misleading: any non-zero return value
(including negative error codes such as -EBUSY or -EAGAIN) tells the PM
core to abort automatic suspension of the device, which is commonly used
by subsystems to prevent immediate runtime suspend.

Clarify that unlike ->runtime_suspend() and ->runtime_resume(), the PM core
does not treat negative return values from ->runtime_idle() as a fatal
device error, and that any non-zero value stops the PM core from
suspending the device.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20260929194956.v3.5.If6e26acac7770c65446dd0b81f891948abb38973@changeid
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 7a93f7e30a3f ("PM: runtime: Update runtime_pm.rst for non-fatal resume errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/power/runtime_pm.rst | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index b0741412d3bc2..2f8d38e417995 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -158,9 +158,14 @@ suspending the device are satisfied) and to queue up a suspend request for the
 device in that case.  If there is no idle callback, or if the callback returns
 0, then the PM core will attempt to carry out a runtime suspend of the device,
 also respecting devices configured for autosuspend.  In essence this means a
-call to pm_runtime_autosuspend(). To prevent this (for example, if the callback
-routine has started a delayed suspend), the routine must return a non-zero
-value.  Negative error return codes are ignored by the PM core.
+call to pm_runtime_autosuspend().
+
+To prevent this suspension (for example, if the callback routine has scheduled
+a delayed suspend or determined the device cannot be idle), the routine must
+return a non-zero value (typically -EBUSY or -EAGAIN).  Unlike
+->runtime_suspend() and ->runtime_resume(), the PM core does not treat negative
+return codes from ->runtime_idle() as a fatal device error; any non-zero value
+simply stops the PM core from suspending the device.
 
 The helper functions provided by the PM core, described in `Section 4`_,
 guarantee that the following constraints are met with respect to runtime PM
-- 
2.53.0



