Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30E31F5831
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 18:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793419; cv=none; b=lsCrNBWDtFB1uG48Gt0trRtCtkqdEGzaRErwufZYK6/JUEdCEYMY/AVxiOz4elglumIQlPIrGseOaRjos5CVxTnDJmeg36yV/RuCprZjDdZgbKMhrlvetCQY6i4RxY3LVnVAHdkMJHH5mI9zhT5/NHHEH/x/aFHmYIwG7aFb5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793419; c=relaxed/simple;
	bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5LVYwTp6CZlALsqLEOCbxPbIgXej5cd6idk2aWTKqe7zRJ3jdyXXUmGIAA/sW0PReCaXV8AcfZHAS3p3oPMKA4/ZnRMf7fJntpV0DbcRxEoDqrbUcrexDch+Fckh7x9aoVk9laWEiwZUEhc2iohQIlB8ZOxCvq4Da+Q9GtPMmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ef8S6oHV; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ef8S6oHV"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2fabb837ddbso19654791fa.1
        for <patches@lists.linux.dev>; Thu, 24 Oct 2024 11:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793416; x=1730398216; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=ef8S6oHVLopjfp2Gl8uoNMWKVoz45GPV3A7pCSU3viOUJTY2qurAcsmUeR4GWTaFIa
         O3MUXxzfwWkQ9rUrW2YNqIY2Xnd6uBj4vbxOsYdk2o0qakXjDt3WQEj9id43+HXEdpic
         JseXrnOMclQxgqVwKS66Cjg1NATfBxQMJA39z+xyGq1FylLOMzJtzwVXzsacTYls6d9P
         MNXap6u38ahCIX6v2lpLkDOFtBXEskzpWH6kIXy67d6eoBIdpJpdkSmoeGbqoWfwRymX
         rlPqh+79lvW5rrr3D0o+hsjRH8sEjEyh4PSBxG4jxkKDJG5otpAFV4Rs8t030R0q1nW7
         7NAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793416; x=1730398216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAHhFzK8bm2wElWsCC8UefckBqxuRKiPoF9FSQoWARc=;
        b=EJJfCltZxn04gYGURRlLMT4rb9rGD0T4WW/ST89ZnC0s9Avgycie1ZsFQLosujip+U
         U3MT2vTE8RnoPwmjZJAetxUDdkjY+JD8NeEtaqbgjFs1gW3z0Xz+bGjdGqIQNsOTXxY/
         W2cqeIcBKyjvhdv8BhlCrYQC7EzkZ4bJ83/ktJfDQoRJ2JcF2+mErfnX6Z+9h+YArbXZ
         /iUip8QLftE/yfL8GGlvPFOEBs/DmwbwYHMYlm+gODI5HP7ew2YHco6mwXC0Ua5Z1SX9
         WsmCiahzzGUZt+raR6k+hW4gMn3DvW3yJDlaPrF/s5ZwcU/bXB1b7m4cSTTu0LxPQvqc
         F5RQ==
X-Gm-Message-State: AOJu0YwgCQF+hB5kMUkLFwb3G9rokcLZoZ2PhGxeRgUEZmRXe2+wiH1O
	6msEhy9LJsAng+N3BTZmgZdMtMxwSOtCAyG8Za5PdatRagHf3iOP
X-Google-Smtp-Source: AGHT+IGHtk9cC82SqwwOFOhlSLKmSHTSfpmy+NL3iPvPRrPnu2IO7tKZQgh2DiIm+TENAYDACPZMSA==
X-Received: by 2002:a05:651c:b2a:b0:2fb:6362:284e with SMTP id 38308e7fff4ca-2fc9d2e61eemr72618661fa.8.1729793415596;
        Thu, 24 Oct 2024 11:10:15 -0700 (PDT)
Received: from localhost.localdomain ([176.106.245.80])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ae24d51sm14440821fa.130.2024.10.24.11.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 11:10:13 -0700 (PDT)
From: Vladimir Putin <vladimirputin693389@gmail.com>
To: gregkh@linuxfoundation.org
Cc: patches@lists.linux.dev
Subject: you should kill yourself now!
Date: Thu, 24 Oct 2024 21:10:02 +0300
Message-ID: <20241024181002.7289-1-vladimirputin693389@gmail.com>
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
