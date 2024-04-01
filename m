Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E83E481C6;
	Mon,  1 Apr 2024 16:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987709; cv=none; b=BBrs5tI1iNOmhg0NbNa4zh+lkd3RtuyVMPKEAyeJNsD0H95Osv2Eugdkj2L49uXntRcaG/Egk7Uz0eFDOupUAl3B3AruH28raMo5CwVnt26qjBOo1ajE0+NKBxxr2rcK9vpHJ3gZZs2X8MpRdgGCLco9o0cnD0Spx9wT8gmS0yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987709; c=relaxed/simple;
	bh=+iDSsduQsBF1L1X8ULMAvCau10F+2KukV1MO9hNDekc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PN9MWNOUZqaXLNHXsGGXm9Zlwa+0mDtByi1tsk7F0Dj4EfHaQDrIXe5PRemIoAJIc5rPN8+Y6pcx/XbSZw0asDx1nm31/wTrlUfTCoFsYBlYoGXp5ngEpa8N8meCJTNehM1YqG5KxALoidZGflXHa1gGA1XY67EsyEiTonCDZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtc5icRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtc5icRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ED3C43394;
	Mon,  1 Apr 2024 16:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987709;
	bh=+iDSsduQsBF1L1X8ULMAvCau10F+2KukV1MO9hNDekc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xtc5icRbA0MUV+qxP0jyWoMO6kN+PQNEGrM8sspk+7/tz2ZQTDFgkW8HBMqswu+19
	 kHgqFCzr2WM6v/6znWdxiShTbYOJIN1VrDMmmxPiFcUeECluObd731qa8lkdPjz+Ma
	 XzjiQIgTDX2CbIQ9YeyNOxa/j6ESWUIrWHn+aqqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.8 369/399] usb: typec: tcpm: Correct port source pdo array in pd_set callback
Date: Mon,  1 Apr 2024 17:45:35 +0200
Message-ID: <20240401152600.191642477@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Tso <kyletso@google.com>

commit 893cd9469c68a89a34956121685617dbb37497b1 upstream.

In tcpm_pd_set, the array of port source capabilities is port->src_pdo,
not port->snk_pdo.

Fixes: cd099cde4ed2 ("usb: typec: tcpm: Support multiple capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Tso <kyletso@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240311144500.3694849-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6117,7 +6117,7 @@ static int tcpm_pd_set(struct typec_port
 
 	if (data->source_desc.pdo[0]) {
 		for (i = 0; i < PDO_MAX_OBJECTS && data->source_desc.pdo[i]; i++)
-			port->snk_pdo[i] = data->source_desc.pdo[i];
+			port->src_pdo[i] = data->source_desc.pdo[i];
 		port->nr_src_pdo = i + 1;
 	}
 


