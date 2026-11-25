Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618458;
	b=rUWjZxWZp3xUNKdKlbnHy/gVxvc5YJxVLvvm5UyoMz6PIx4XEqNhkGM9iQGAwDn7fnwQ
	 CrWcY4q72HdWbbyvZXeWtlgT4z2v4WRj1wpLsqU3h7A5Bo/tAbBuNlYv0mwTWKUWBUrs8
	 g0UZn4lRg77NhXY3Ym8e1leIwXNVbNEaDDdru3tO+ojkQkXg5fCGrsmXuKY/W2XBXWmtk
	 NMlhp/n2k7hqH4SWDgaagb2oM2hdbBZ8bWK9UjrjgS9q1MQc3n99rHnWBMtPDVKR7qs9y
	 9IPDeGIsm11cETlPK5CvWSUS66zs4ax1sfILb/0KWQh9xMxIslfkggnFpZirZcv0V6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UB5MNr72srUJp2O0LqK7/j5njnz7oZIwyABGV5XIhAk=;
	b=SLsmYs81wkLl86/Hc9tm7HLouRaosGuvYw1X+TsF6SU1sRDhxOKOB587jWr+XShR+M28
	 JMqTi/ZAAEhdYRgcpMnfpAiLac1FWfzg+x118O9ywMneGkTgdfQOkxTKdPaScF6KwC8zG
	 UuhkoD71xTc6VV4bYXLu89uKcI8t+hwA5iZWAp/qGD8MOc+85UkYvpfF6riodTsqc40sr
	 KL+cyFJFXcIsI3PFiGcY7wQSz6DHhm6d1T83Na4oVSU2ULQG6M78n+dA1SdArDmFZ3qlX
	 Wf68MWX8nn9fXC1jzAkQ+XJflpEfWMbmqyQuU0FJVHC+Dr1mtps5ABYj5RYSpD6meEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwUl8FBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28401606A321;
	Wed, 25 Nov 2026 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cwUl8FBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105461F000D0;
	Wed, 25 Nov 2026 14:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618457;
	bh=UB5MNr72srUJp2O0LqK7/j5njnz7oZIwyABGV5XIhAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cwUl8FBwLqvdkcNlHLm22oDNhfWrgXvkwkONJefLst2xwTIB6sS2r7XnB8aduMd+A
	 MiVRs6Adnf4pFKIgQhhc84zClm4DB4KTP8SpRM12ff8w13eZD2pvS/AyQ8zNuxhSDj
	 RAqumU6Njebx/dq4kEUQ9yWQLaXF8fcJe/50t+Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Brian Norris <briannorris@chromium.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0286/1005] PM: runtime: Update runtime_pm.rst for non-fatal resume errors
Date: Wed, 25 Nov 2026 15:27:04 +0100
Message-ID: <20261125143828.441925214@linuxfoundation.org>
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

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 7a93f7e30a3f7c8dd4f5fe4cde54d01c8018e2bc ]

Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
suspend callback failures"), rpm_callback() no longer sets
dev->power.runtime_error when ->runtime_resume() returns an error.
However, Documentation/power/runtime_pm.rst still states in both the
resume callback rules and the ->runtime_idle() comparison that the PM
core treats ->runtime_resume() errors as fatal device errors and blocks
runtime PM helper functions until the status is manually reset.

Update the resume callback semantics bullet to state that on error the
PM core resets the runtime PM status to 'suspended', returns the error
code from synchronous resume helpers, and unlike with the suspend
callback never treats resume failures as fatal, leaving the Section 4
runtime PM helpers unblocked so a subsequent resume request can run
->runtime_resume() again. Also drop ->runtime_resume() from the
->runtime_idle() fatal-error comparison.

Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
Fixes: aedc51762a0d ("PM: runtime: Clarify ->runtime_idle() callback return value handling")
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
[ rjw: Adjustment of the resume callback errors bullet point ]
Link: https://patch.msgid.link/20261104151651.3035537-1-stanleyjhu@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/power/runtime_pm.rst | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/power/runtime_pm.rst b/Documentation/power/runtime_pm.rst
index 2f8d38e417995..92281f70c9d3a 100644
--- a/Documentation/power/runtime_pm.rst
+++ b/Documentation/power/runtime_pm.rst
@@ -135,11 +135,12 @@ what to do to handle the device).
     I/O operations as needed.  The runtime PM status of the device is then
     'active'.
 
-  * If the resume callback returns an error code, the PM core regards this as a
-    fatal error and will refuse to run the helper functions described in
-    `Section 4`_ for the device, until its status is directly set to either
-    'active', or 'suspended' (by means of special helper functions provided by
-    the PM core for this purpose).
+  * If the resume callback returns an error code, the PM core sets the
+    device's runtime PM status back to 'suspended' and returns the error
+    code from synchronous resume helpers.  Unlike most suspend callback
+    errors, failures in the resume callback are never considered fatal,
+    so the helper functions described in `Section 4`_ are not blocked and
+    a subsequent resume request can run the resume callback again.
 
 The idle callback (a subsystem-level one, if present, or the driver one) is
 executed by the PM core whenever the device appears to be idle, which is
@@ -163,9 +164,9 @@ call to pm_runtime_autosuspend().
 To prevent this suspension (for example, if the callback routine has scheduled
 a delayed suspend or determined the device cannot be idle), the routine must
 return a non-zero value (typically -EBUSY or -EAGAIN).  Unlike
-->runtime_suspend() and ->runtime_resume(), the PM core does not treat negative
-return codes from ->runtime_idle() as a fatal device error; any non-zero value
-simply stops the PM core from suspending the device.
+->runtime_suspend(), the PM core does not treat negative return codes from
+->runtime_idle() as a fatal device error, and any non-zero value simply stops
+the PM core from suspending the device.
 
 The helper functions provided by the PM core, described in `Section 4`_,
 guarantee that the following constraints are met with respect to runtime PM
-- 
2.53.0



