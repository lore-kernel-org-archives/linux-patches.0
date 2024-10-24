Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C571FBF50
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793396; cv=none; b=N22QBv/gEmrd1emcmMYUqXQDyQZljZ1CV4fL3bC8ueb4MrqTtCyJ0m7CNccuDorIi4wP5LTD2tNIv5LY8AnEHPHTYmCIcN6MQxaQdVVHEmL79wEmMk5fvFm/d2UXPCrUwAa502vv8bTl9jZKrKlnjzz5gK+8RmTbRQo0zE7RMJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793396; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmClN3reoa9xJ+vgwoi2gvuca/xADVg8vi0KXYjLdbm6GqEF/gZJVc3Jko7BAw0j1oACCgI8fCwrY60LyMJpU21qJfQa56qRL3Tri5t+agFklOzLPCRhYLiRZQhomSQfHqcJASwkB2xNGcl3V6nmQnF5hXPJ1S3UE1XM3ivXQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f3lZILj3; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f3lZILj3"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539f76a6f0dso1212356e87.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793393; x=1730398193; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=f3lZILj3Rnhn+tmHJ3A0Ge2994quCqVtePjSZJtAjz3VGl/BGlpa/rbGeTFvM7MmNM
         vrYllISWnlMAEqoHnVTuEbcQob5JQhlJqUvqqjOO1twzqfUnvS0Y3EDIAAw7N2mIeFPI
         x8DxsA0LBhJ1woi+oBWaJBCuBctfkTH+s5UgXDYFLMlsrwQlj4p+LlK2PbsnzjM/TVpV
         AS8sAJ1IUfp4iNZAHT0g016VwXG6MPqsKcKuJOEpCD73Jm0ladYTxc0L3UvnnfbG6GXN
         Hry/yWRZTUYUEfF/rRFztEFFF/l5dvYRxnJ+699Q333dHYeDbvqq6smPE+Bj9gcPHS7Q
         aZdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793393; x=1730398193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=KNezzu+aVUPTKLaud24y7Btw2fEY6mehrb0bohRECCjBq44Qf2yqgVdw0LyaDY3z2v
         pma28WYwOjoxQuo7jNIg6a9xBNqCpRbSSaGwhK3lDfSK1yeC9UHrwTHfvrjHZLQMHP27
         lEMPVfN+0G7ikpnx/bJj32n9AK6t6fBOUNh7I7ECUqCdTneM9t0cIRFScJOBV4haNnxF
         DIk1u7Ns7EcbuehQoJ2tHWH5ntYfMm1yn+ehSul0Mi591fIxjBerJhD3Tc8XBJH1n1UU
         lhgD5d3jRJg+t5iE/zef/DJC+K3H/mCo0sLVKtyc9IcKi3hxmbZ6IoJ0gOfYA6b1Xb46
         2I6Q==
X-Gm-Message-State: AOJu0YylJBUt11Td7c2bqphAcEpzO634NQTTZAAVqX6Bu3FKidoRTPAw
	6MI0eUYzRpRYcAh6aRVTn1BoWMgLucsc2QVMgBQ6cMkbrkgRa5lK
X-Google-Smtp-Source: AGHT+IF9EpESNTVwqqta+yssxfXViRzdw59GUU9JFQu48NjuhsWikotq1IreNPLUecaNkOK1hfcDNA==
X-Received: by 2002:a05:6512:1599:b0:539:f26f:d285 with SMTP id 2adb3069b0e04-53b1a2fb015mr4645984e87.3.1729793392898;
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53a223e5accsm1454864e87.61.2024.10.24.11.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:09:52 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:09:46 +0300
Message-ID: <20241024180946.4539-1-vladimirputin693389@gmail.com>
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
