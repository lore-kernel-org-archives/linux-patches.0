Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C601FF7DA
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793408; cv=none; b=BQts/vSbMdqNb/NS6eM/NAifSvtZUN8c4QfmbpnH5cTODg3Nv3OmqZvgcAwlLCPWgk2ohp1gT3zllPtDjFXF77cKIx2sG3/7UtAmZU+n5qfIZM+qqMj7+c9lvCE23/zaiuKbsKQ3VZG6zkbPYhnJzKjLcLpdmwEDFmiBL+gBXSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793408; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgjU9SAKQFEgBiDjJsOvb2Rc23I/qbzitS7IOGRLQZZ9LhZ1nXCujCXqPepoZM2QPV5/GOeviNLD/hYnHe00rTWg0qC9h92fTCIVlQGBCZV3VTlbZ26BctirCy062zWf/RTmeSmmNem9GBMiHGY9xsWG1bO7wpux1111p/1r8iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fY3OfhGa; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fY3OfhGa"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539f0f9ee49so1253807e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793405; x=1730398205; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=fY3OfhGape8aphsOYT3rQOTVJPOgjlV9Pq/GNnVeHFtHsx6YuWdm4tUaO8ljejA2Ty
         FLW3QpT/eukfTKF7qNfM0ce4IoR4N5XPH9+cVi59Ybve3JatIfASQrgk4m9Zm2U0FDIt
         n7imhasa259SJDWi4xkJ19b+0MTeOh2kzOPAgFV3bHPQWp7BXLug9k60xyQLlu5xgASU
         k1oiZAOAXBJIp6y2JozHN00rna2fBr4KOu1uwbL3Qvq81C6FwzXhGZSOYIN2WhSTkF7Y
         Hee1pj/OAZm3iAJzw2h0ZD995JxaP6RnHQSxiXdqt1tuFWYuhmbh740RrnUGl7ykyl48
         l3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793405; x=1730398205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=qyO80QlWPWPpUE9Q+khKBwhORsgAeJlgpZgq40zRDokwHaHFrVJ7qPcIowZ/jVeENM
         MHLWPsPK5QxFwFF+Y7fVJcsb7CKEb8Nk51OeDoSJ8PzbJJGDNdS4ehl6DMO7wDJjy6RZ
         VoW5zlP0dm1UW1qp1X35/iP7m73V2P6Lw99kTBRNS6dxfGncyjUQo8vakNfB6r88FrJe
         as1uRO2w6TTsotbcOqMDViUHAVnyKxsoEuTmXunXSjwDZr4I/4VSjMne+unXevi3fh1P
         aUnSGUGsm8XFqw2wMVqzrew2NRDB8uMoWhuTMXZ3X22+qn4EojNn8AywLOlQl2FUU8i1
         c2Sg==
X-Gm-Message-State: AOJu0YzfWYOa5NRmmH+k4bH0iT1eMNrsWr0Lsrmtkb2fGTxtuIl+3xIX
	zdOcxTqQytw3iTyo/UVz67vSvcdafc3cJpU6oziyRkWdcHx6CNSTUyw6457F
X-Google-Smtp-Source: AGHT+IFc0jASPXdIU/SKfpRDCzdZY9YGuZcNwkQAo5nHW+boTwDe2Doih4ZYV/r2oIR6FbsvwpQkfg==
X-Received: by 2002:ac2:4c4d:0:b0:52c:e17c:3741 with SMTP id 2adb3069b0e04-53b23dde253mr2111970e87.5.1729793404424;
        Thu, 24 Oct 2024 11:10:04 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223efeb2sm1437551e87.73.2024.10.24.11.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:03 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:53 +0300
Message-ID: <20241024180953.5903-1-vladimirputin693389@gmail.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <2024101835-tiptop-blip-09ed@gregkh>
References: <2024101835-tiptop-blip-09ed@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

You should kill yourself NOW!
